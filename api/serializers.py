from rest_framework import serializers
from .models import Service, Booking
from django.contrib.auth.models import User

class ServiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = Service
        fields = '__all__'



# {'user': 1, 'service': 1, 'additional_service': 'Extra towels', 'call': '1234567890', 'time': '10:30:00', 'date': '2024-12-15', 'latitude': 12.8742149, 'longitude': 74.9392862}
class BookingSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())

    class Meta:
        model = Booking
        fields = ['id', 'user', 'service', 'additional_service', 'call', 'time', 'date', 'latitude', 'longitude']


class OrderSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())

    class Meta:
        model = Booking
        fields = ['id', 'user', 'service', 'additional_service', 'status1','status2','status3']


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'is_staff']