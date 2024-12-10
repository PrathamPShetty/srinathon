from django.contrib import admin
from .models import  Booking, Service # Import your models

admin.site.register(Booking)
admin.site.register(Service)

