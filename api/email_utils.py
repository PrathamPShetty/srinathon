from django.core.mail import send_mail


def send_email(subject, message, recipient):
    send_mail(
        subject=subject,
        message=message,
        from_email="prathampshetty99sai@gmail.com",
        recipient_list=[recipient],
    )


def send_success_email(email, booking):
    send_email(
        subject="Booking Confirmation",
        message=f"Your booking for {booking.service.name} on {booking.date} at {booking.time} is confirmed.",
        recipient=email,
    )


def send_failure_email(email):
    send_email(
        subject="Booking Failed",
        message="There was an issue with your booking. Please try again.",
        recipient=email,
    )
