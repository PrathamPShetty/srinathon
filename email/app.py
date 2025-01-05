from fastapi import FastAPI, Form, UploadFile, HTTPException
from pydantic import BaseModel, EmailStr
from typing import Annotated
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.application import MIMEApplication
import os

app = FastAPI()

# Define a Pydantic model for the email request body
class EmailRequest(BaseModel):
    receiver_email: EmailStr
    subject: str
    body: str

@app.post("/send-email/")
async def send_email_endpoint(
    receiver_email: Annotated[EmailStr, Form(...)],
    subject: Annotated[str, Form(...)],
    body: Annotated[str, Form(...)] = "<p>Here is your certificate.</p>",
  
):
    sender_email = "prathampshetty99sai@gmail.com"
    sender_password = "dlwofqozvkvwmwyi"  


    try:
        with open(pdf_path, "wb") as file:
            file.write(await pdf_file.read())

        # Send email
        message = MIMEMultipart()
        message["From"] = sender_email
        message["To"] = receiver_email
        message["Subject"] = subject
        message.attach(MIMEText(body, "html"))

        with open(pdf_path, "rb") as attachment:
            part = MIMEApplication(attachment.read(), _subtype="pdf")
            part.add_header("Content-Disposition", "attachment", filename="Certificate.pdf")
            message.attach(part)

        text = message.as_string()

        with smtplib.SMTP("smtp.gmail.com", 587) as server:
            server.starttls()
            server.login(sender_email, sender_password)
            server.sendmail(sender_email, receiver_email, text)
            return {"message": f"Email successfully sent to {receiver_email}"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to send email: {str(e)}")
    finally:
        if os.path.exists(pdf_path):
            os.remove(pdf_path)
