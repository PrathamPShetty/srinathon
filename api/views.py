from django.shortcuts import render

# Create your views here.
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Booking
from .serializers import BookingSerializer
from .email_utils import send_success_email, send_failure_email


class BookingView(APIView):
    def post(self, request, *args, **kwargs):
        serializer = BookingSerializer(data=request.data)
        if serializer.is_valid():
            booking = serializer.save()
            send_success_email("prathampshetty99sai@gmail.com", booking)
            return Response({"message": "Booking successful!"}, status=status.HTTP_201_CREATED)
        else:
            send_failure_email(request.user.email)
            return Response({"errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
