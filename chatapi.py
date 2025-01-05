from fastapi import FastAPI, HTTPException, Query
from pydantic import BaseModel, Field, EmailStr
from deep_translator import GoogleTranslator
import ollama
import json
import os
from datetime import datetime
from typing import Optional

app = FastAPI()

MODEL_NAME = 'mario'
LANGUAGE_CODES = {
    '1': 'en',  # English
    '2': 'ml',  # Malayalam
    '3': 'ta',  # Tamil
    '4': 'kn'   # Kannada
}

LANGUAGE_NAMES = {
    '1': 'English',
    '2': 'Malayalam',
    '3': 'Tamil',
    '4': 'Kannada'
}

USERS_DB_PATH = 'users_database.json'


class User(BaseModel):
    username: str
    first_name: str
    last_name: str
    email: EmailStr
    age: int = Field(..., gt=0, lt=120)
    registration_date: Optional[str] = None
    purchases: Optional[list] = []


class ChatRequest(BaseModel):
    username: str
    query: str


def create_or_load_database():
    """Load the users database or create a dummy one."""
    if os.path.exists(USERS_DB_PATH):
        try:
            with open(USERS_DB_PATH, 'r') as f:
                return json.load(f)
        except (json.JSONDecodeError, FileNotFoundError):
            return create_dummy_database()
    else:
        return create_dummy_database()


def create_dummy_database():
    """Create a dummy database with sample user data."""
    dummy_users = {
        "john_smith": {
            "username": "john_smith",
            "first_name": "John",
            "last_name": "Smith",
            "email": "john.smith@example.com",
            "age": 35,
            "registration_date": "2023-01-15",
            "purchases": []
        }
    }
    # Save dummy database to file
    with open(USERS_DB_PATH, 'w') as f:
        json.dump(dummy_users, f, indent=4)
    return dummy_users


def translate_text(text: str, target_lang: str = 'en') -> str:
    """Translate text using Google Translator."""
    try:
        return GoogleTranslator(source='auto', target=target_lang).translate(text)
    except Exception as e:
        print(f"Translation error: {e}")
        return text


async def generate_response(query: str, user_profile: dict, language_code: str) -> str:
    """Generate response using ollama and return in the selected language."""
    # Translate query to English for model processing
    english_query = translate_text(query, 'en')

    # Prepare prompt with user context if available
    if user_profile:
        context_prompt = f"User Profile Context:\n{json.dumps(user_profile, indent=2)}\n\n"
        full_prompt = context_prompt + f"User Query: {english_query}"
    else:
        full_prompt = english_query

    try:
        # Generate response in English using ollama model
        response = ollama.generate(
            model=MODEL_NAME,
            prompt=full_prompt,
            options={
                'temperature': 0.7,
                'top_p': 0.95,
                'max_tokens': 300
            }
        )
        
        # Translate the response back to the selected language
        translated_response = translate_text(response['response'], target_lang=language_code)
        return translated_response
    except Exception as e:
        print(f"Error generating response: {e}")
        return translate_text("I'm having trouble processing your request right now. Can you please try again?", target_lang=language_code)


@app.post("/chat")
async def chat(
    chat: ChatRequest, 
    lang: str = Query(..., description="Language code", regex="^(1|2|3|4)$")
):
    """Handle chat request."""
    # Load user database
    users_db = create_or_load_database()

    # Fetch user profile based on username
    user_profile = users_db.get(chat.username)
    if not user_profile:
        raise HTTPException(status_code=404, detail="User not found")

    # Generate and translate response
    response = await generate_response(chat.query, user_profile, LANGUAGE_CODES[lang])
    
    return {"response": response}


@app.post("/register")
async def register(user: User):
    """Register a new user."""
    users_db = create_or_load_database()

    # Check if user already exists
    if user.username in users_db:
        raise HTTPException(status_code=400, detail="Username already exists")

    # Save user to the database
    user_profile = user.dict()
    user_profile["registration_date"] = datetime.now().strftime("%Y-%m-%d")
    users_db[user.username] = user_profile

    # Save updated database
    with open(USERS_DB_PATH, 'w') as f:
        json.dump(users_db, f, indent=4)

    return {"message": f"User {user.username} registered successfully!"}


@app.get("/test")
async def root():
    return {"message": "Welcome to the ZetaOneChat API. Use /chat and /register endpoints."}
