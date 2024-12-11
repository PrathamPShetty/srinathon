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
from .serializers import ServiceSerializer, UserSerializer, OrderSerializer
from .models import Service 
from django.contrib.auth.models import User
from rest_framework import serializers

# from django.contrib.gis.geos import Point

client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_SECRET_KEY))

class ServiceListView(APIView):
    def get(self, request, *args, **kwargs):
        # Fetch all services
        services = Service.objects.all()
        # Serialize the data
        serializer = ServiceSerializer(services, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class UserListView(APIView):
    def get(self, request, *args, **kwargs):
        users = User.objects.filter(is_staff=True) 
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class OrderView(APIView):
    def get(self, request, *args, **kwargs):
        users = Booking.objects.all() 
        serializer = OrderSerializer(users, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class BookingView(APIView):
    def post(self, request, *args, **kwargs):
        serializer = BookingSerializer(data=request.data)
        if serializer.is_valid():
        
            booking = serializer.save()

            
            service_price = booking.service.price

            # Send a success email
            send_success_email("prathampshetty99sai@gmail.com", booking)

            # Include the booking ID and service price in the response
            return Response(
                {
                    "message": "Booking successful!",
                    "booking_id": booking.id,
                    "service_price":int( service_price ),
                },
                status=status.HTTP_201_CREATED,
            )
        else:
            print(request.data)
            # Send a failure email if the request is invalid
            send_failure_email("prathampshetty99sai@gmail.com")
            return Response(
                {"errors": serializer.errors},
                status=status.HTTP_400_BAD_REQUEST,
            )


        



class BookingSerializer(serializers.ModelSerializer):
    latitude = serializers.FloatField(write_only=True)
    longitude = serializers.FloatField(write_only=True)

    class Meta:
        model = Booking
        fields = '__all__'

    def create(self, validated_data):
        latitude = validated_data.pop('latitude')
        longitude = validated_data.pop('longitude')
        validated_data['location'] = Point(longitude, latitude)
        return super().create(validated_data)






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




# from django.contrib.gis.db.models.functions import Distance
# from django.contrib.gis.geos import Point
# from django.shortcuts import get_list_or_404

# def nearest_bookings(request):
#     user_latitude = float(request.query_params.get('latitude'))
#     user_longitude = float(request.query_params.get('longitude'))
#     user_location = Point(user_longitude, user_latitude, srid=4326)

#     # Get bookings ordered by distance
#     bookings = Booking.objects.annotate(
#         distance=Distance('location', user_location)
#     ).order_by('distance')

#     serializer = BookingSerializer(bookings, many=True)
#     return Response(serializer.data)


# from django.contrib.gis.measure import D  # For distance units

# def nearest_bookings_within_radius(request):
#     user_latitude = float(request.query_params.get('latitude'))
#     user_longitude = float(request.query_params.get('longitude'))
#     user_location = Point(user_longitude, user_latitude, srid=4326)

#     radius = 10  
#     bookings = Booking.objects.filter(
#         location__distance_lt=(user_location, D(km=radius))
#     ).annotate(
#         distance=Distance('location', user_location)
#     ).order_by('distance')

#     serializer = BookingSerializer(bookings, many=True)
#     return Response(serializer.data)

