import os
import json
from typing import Dict, List, Optional
from transformers import AutoModelForCausalLM, AutoTokenizer
import torch
import sqlite3
import datetime

class ZetaOneChatSystem:
    def __init__(self, 
                 llm_model_path: str, 
                 database_path: str = 'user_data.db'):
        """
        Initialize the ZetaOne Chat System with local LLM and user database
        
        :param llm_model_path: Path to the local LLM model
        :param database_path: Path to the SQLite user database
        """
        # Load Local LLM
        self.tokenizer = AutoTokenizer.from_pretrained(llm_model_path)
        self.model = AutoModelForCausalLM.from_pretrained(llm_model_path)
        
        # Database Connection
        self.conn = sqlite3.connect(database_path)
        self.create_database_schema()
    
    def create_database_schema(self):
        """
        Create necessary database tables for chat and user history
        """
        cursor = self.conn.cursor()
        
        # User Purchase History Table
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS purchase_history (
            user_id TEXT,
            service_type TEXT,
            service_provider TEXT,
            purchase_date DATE,
            total_amount REAL,
            service_details TEXT
        )
        ''')
        
        # Chat History Table
        cursor.execute('''
        CREATE TABLE IF NOT EXISTS chat_history (
            chat_id TEXT PRIMARY KEY,
            user_id TEXT,
            service_provider_id TEXT,
            message_history TEXT,
            start_time DATETIME,
            last_updated DATETIME
        )
        ''')
        
        self.conn.commit()
    
    def get_user_purchase_history(self, user_id: str) -> List[Dict]:
        """
        Retrieve user's purchase history
        
        :param user_id: Unique identifier for the user
        :return: List of purchase history dictionaries
        """
        cursor = self.conn.cursor()
        cursor.execute('''
            SELECT service_type, service_provider, 
                   purchase_date, total_amount, service_details 
            FROM purchase_history 
            WHERE user_id = ?
        ''', (user_id,))
        
        columns = ['service_type', 'service_provider', 
                   'purchase_date', 'total_amount', 'service_details']
        return [dict(zip(columns, row)) for row in cursor.fetchall()]
    
    def generate_context_prompt(self, user_id: str, query: str) -> str:
        """
        Generate a contextual prompt using user's purchase history
        
        :param user_id: Unique user identifier
        :param query: User's chat query
        :return: Contextualized prompt
        """
        purchase_history = self.get_user_purchase_history(user_id)
        
        if not purchase_history:
            return f"User query: {query}\nNo previous purchase history available."
        
        # Summarize purchase history
        history_summary = "User Purchase History:\n"
        for purchase in purchase_history:
            history_summary += (
                f"- {purchase['service_type']} from {purchase['service_provider']} "
                f"on {purchase['purchase_date']}, Amount: ${purchase['total_amount']}\n"
            )
        
        return f"{history_summary}\n\nUser Query: {query}"
    
    def generate_response(self, 
                          user_id: str, 
                          query: str, 
                          max_tokens: int = 150) -> str:
        """
        Generate an AI response using local LLM
        
        :param user_id: Unique user identifier
        :param query: User's chat message
        :param max_tokens: Maximum tokens for response
        :return: AI-generated response
        """
        context_prompt = self.generate_context_prompt(user_id, query)
        
        # Tokenize input
        inputs = self.tokenizer(context_prompt, return_tensors="pt")
        
        # Generate response
        outputs = self.model.generate(
            inputs.input_ids, 
            max_length=inputs.input_ids.shape[1] + max_tokens,
            num_return_sequences=1,
            no_repeat_ngram_size=2
        )
        
        # Decode response
        response = self.tokenizer.decode(outputs[0], skip_special_tokens=True)
        
        return response
    
    def save_chat_history(self, 
                           chat_id: str, 
                           user_id: str, 
                           service_provider_id: str, 
                           message_history: List[Dict]):
        """
        Save chat history to database
        
        :param chat_id: Unique chat identifier
        :param user_id: User identifier
        :param service_provider_id: Service provider identifier
        :param message_history: List of messages in the conversation
        """
        cursor = self.conn.cursor()
        cursor.execute('''
            INSERT OR REPLACE INTO chat_history 
            (chat_id, user_id, service_provider_id, message_history, start_time, last_updated)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (
            chat_id, 
            user_id, 
            service_provider_id, 
            json.dumps(message_history),
            datetime.datetime.now(),
            datetime.datetime.now()
        ))
        self.conn.commit()
    
    def close_connection(self):
        """
        Close database connection
        """
        self.conn.close()

# Example Usage
def main():
    # Initialize chat system with a local LLM model
    chat_system = ZetaOneChatSystem(
        llm_model_path='path/to/local/llm/model'
    )
    
    # Simulated user interaction
    user_id = 'user123'
    query = "I need help with my recent AC service"
    
    response = chat_system.generate_response(user_id, query)
    print("AI Response:", response)
    
    # Optional: Save chat history
    chat_system.save_chat_history(
        chat_id='chat_001', 
        user_id=user_id, 
        service_provider_id='provider456', 
        message_history=[
            {"sender": "user", "message": query},
            {"sender": "ai", "message": response}
        ]
    )
    
    chat_system.close_connection()

if __name__ == "__main__":
    main()
