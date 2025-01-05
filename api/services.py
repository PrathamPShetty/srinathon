# import smtplib
# from email.mime.text import MIMEText
# from email.mime.multipart import MIMEMultipart
# from django.conf import settings
# from .models import Booking

# def send_booking_notification(booking: Booking):
#     """Sends an email notification after a booking is created."""
    
#     # Set up the SMTP server and login
#     smtp_server = settings.SMTP_SERVER
#     smtp_port = settings.SMTP_PORT
#     smtp_user = settings.SMTP_USER
#     smtp_password = settings.SMTP_PASSWORD

  
#     sender_email = smtp_user
#     recipient_email = booking.user.email  

#     subject = "Service Booking Confirmation"
#     body = f"""
#     Hello {booking.user.first_name} {booking.user.last_name},

#     Your booking for {booking.service.name} has been confirmed.

#     Service Type: {booking.service.name}
#     Worker: {booking.service.worker}
#     Date: {booking.date}
#     Time: {booking.time}
    
#     Additional Service: {booking.additional_service}
#     Contact Details: {booking.call}

#     Thank you for choosing our service!

#     Best regards,
#     Your Service Team
#     """

#     # Set up the MIMEText object
#     msg = MIMEMultipart()
#     msg['From'] = sender_email
#     msg['To'] = recipient_email
#     msg['Subject'] = subject
#     msg.attach(MIMEText(body, 'plain'))

#     try:
#         # Connect to the SMTP server and send the email
#         with smtplib.SMTP(smtp_server, smtp_port) as server:
#             server.starttls()  # Secure the connection
#             server.login(smtp_user, smtp_password)
#             server.sendmail(sender_email, recipient_email, msg.as_string())
#         print("Booking confirmation email sent successfully.")

#     except Exception as e:
#         print(f"Error sending email: {e}")

# # Booking Views
# @api_view(['GET'])
# @permission_classes([IsAuthenticated])
# def getBookings(request):
#     user = request.user
#     bookings = Booking.objects.filter(user=user)
#     serializer = BookingSerializer(bookings, many=True)
#     return Response(serializer.data)
