import razorpay
from django.conf import settings
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.exceptions import APIException
from django.shortcuts import render

# Create your views here.
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Booking
from .serializers import BookingSerializer
from .email_utils import send_success_email, send_failure_email
import razorpay
from django.conf import settings
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponseBadRequest

client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_SECRET_KEY))

class BookingView(APIView):
    def post(self, request, *args, **kwargs):
        serializer = BookingSerializer(data=request.data)
        if serializer.is_valid():
            # Save the booking and get the instance
            booking = serializer.save()

            # Fetch the service price
            service_price = booking.service.price

            # Send a success email
            # send_success_email("prathampshetty99sai@gmail.com", booking)

            # Include the booking ID and service price in the response
            return Response(
                {
                    "message": "Booking successful!",
                    "booking_id": booking.id,
                    "service_price": service_price,
                },
                status=status.HTTP_201_CREATED,
            )
        else:
            # Send a failure email if the request is invalid
            # send_failure_email(request.user.email)
            return Response(
                {"errors": serializer.errors},
                status=status.HTTP_400_BAD_REQUEST,
            )






@api_view(['POST'])
def create_order(request):
    try:
        # Get the service ID from the request
        service_id = request.data.get("service_id")
        if not service_id:
            raise APIException("Service ID is required")

        # Fetch the service from the database
        service = Service.objects.get(id=service_id)

        # Get the price of the service
        amount = service.price
        if not amount:
            raise APIException("Service price is not set")

        # Razorpay expects the amount in paise
        razorpay_order = client.order.create(
            {"amount": int(amount) * 100, "currency": "INR", "receipt": f"order_rcptid_{service_id}"}
        )

        # Save order details in the database
        Payment.objects.create(
            order_id=razorpay_order["id"],
            amount=amount,
            service=service,
            status="created"
        )

        return Response({"order_id": razorpay_order["id"], "amount": amount})
    except Service.DoesNotExist:
        raise APIException("Service not found")
    except Exception as e:
        raise APIException(str(e))