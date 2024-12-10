
from django.db import models
from django.contrib.auth.models import AbstractUser, Group, Permission

class CustomUser(AbstractUser):
    first_name = models.CharField(max_length=50, null=True)
    last_name = models.CharField(max_length=50, null=True)
    email = models.EmailField(unique=True, null=True)
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    address = models.TextField(blank=True, null=True)
    date_of_birth = models.DateField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    # Override groups and user_permissions with unique related_name
    groups = models.ManyToManyField(
        Group,
        related_name="customuser_set",  # Avoid conflict
        blank=True,
        help_text="The groups this user belongs to.",
        verbose_name="groups",
    )
    user_permissions = models.ManyToManyField(
        Permission,
        related_name="customuser_set",  # Avoid conflict
        blank=True,
        help_text="Specific permissions for this user.",
        verbose_name="user permissions",
    )

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

class Service(models.Model):
    name = models.CharField(max_length=255, help_text="Name of the service")
    worker = models.CharField(max_length=255, help_text="Name of the worker providing the service")
    address = models.TextField(help_text="Address where the service is provided")
    email = models.EmailField(help_text="Contact email for the service")
    phone = models.CharField(max_length=15, help_text="Contact phone number for the service")
    price = models.DecimalField(max_digits=10, decimal_places=2, help_text="Price of the service")
    availability = models.BooleanField(default=True, help_text="Availability status of the service")

    def __str__(self):
        return f"{self.name} by {self.worker}"

from django.db import models

class Booking(models.Model):
    SERVICE_CHOICES = [
        ('cleaning', 'Cleaning'),
        ('consultation', 'Consultation'),
        ('repair', 'Repair'),
        # Add more services as needed
    ]
    
    service = models.CharField(
        max_length=50,
        choices=SERVICE_CHOICES,
        default='consultation',
        help_text="Type of service being booked."
    )
    call = models.CharField(
        max_length=100,
        help_text="Contact information or details about the call."
    )
    time = models.TimeField(
        help_text="Time of the booking."
    )
    date = models.DateField(
        help_text="Date of the booking."
    )
    notification = models.BooleanField(
        default=False,
        help_text="Whether a notification has been sent or not."
    )

    def __str__(self):
        return f"{self.service} on {self.date} at {self.time}"


