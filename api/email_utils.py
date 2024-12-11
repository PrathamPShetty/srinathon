from django.core.mail import send_mail

# Email configuration (ensure these settings are also in your Django settings.py file)
SENDER_EMAIL = "prathampshetty99sai@gmail.com"
SENDER_PASSWORD = "dlwofqozvkvwmwyi"  # Replace with your app password

def send_email(subject, message, recipient):
    """Send an email using Django's send_mail."""
    try:
        send_mail(
            subject=subject,
            message=message,
            from_email=SENDER_EMAIL,
            recipient_list=[recipient],
        )
        print(f"Email successfully sent to {recipient}")
    except Exception as e:
        print(f"Failed to send email to {recipient}: {str(e)}")

def send_success_email(email, booking):
    """Send success email for a booking."""
    try:
        send_email(
            subject="Booking Confirmation",
            message=(
                f"Dear {booking.user.name},\n\n"
                f"Your booking for {booking.service.name} on {booking.date} "
                f"at {booking.time} has been successfully confirmed.\n\n"
                "Thank you for choosing our service!"
            ),
            recipient=email,
        )
    except AttributeError as e:
        print(f"Error preparing email content: {str(e)}")

def send_failure_email(email):
    """Send failure email for a booking."""
    try:
        send_email(
            subject="Booking Failed",
            message=(
                "Dear Customer,\n\n"
                "Unfortunately, there was an issue with your booking. Please try again later, "
                "or contact our support team for assistance.\n\n"
                "We apologize for the inconvenience."
            ),
            recipient=email,
        )
    except Exception as e:
        print(f"Failed to send failure email: {str(e)}")
