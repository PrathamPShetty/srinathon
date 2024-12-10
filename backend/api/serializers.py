from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import CustomUser

class MyTokenObtainPairSerializer(TokenObtainPairSerializer):
    def validate(self, attrs):
        data = super().validate(attrs)
        data['user_id'] = self.user.id
        data['username'] = self.user.username
        data['email'] = self.user.email
        return data

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = CustomUser
        fields = ['username', 'email', 'password', 'first_name', 'last_name', 'phone_number', 'address']
    def create(self, validated_data):
        user = CustomUser.objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            first_name=validated_data.get('first_name', ''),
            last_name=validated_data.get('last_name', ''),
            phone_number=validated_data.get('phone_number', ''),
            address=validated_data.get('address', ''),
        )
        return user

from rest_framework import serializers
from .models import Service

from .models import Service
from django.contrib.auth.hashers import make_password

class RegisterServiceSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = Service
        fields = ['email', 'password', 'name', 'worker', 'phone', 'address', 'price', 'availability']

    def create(self, validated_data):
        # Create the Service instance with the hashed password
        service = Service.objects.create(
            email=validated_data['email'],
            password=validated_data['password'],  # raw password will be hashed in the model's set_password method
            name=validated_data['name'],
            worker=validated_data['worker'],
            phone=validated_data['phone'],
            address=validated_data['address'],
            price=validated_data['price'],
            availability=validated_data['availability'],
        )
        service.set_password(validated_data['password'])  # Hash the password before saving
        service.save()
        return service


class ProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'phone_number', 'address', 'date_of_birth']



