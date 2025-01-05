from django.contrib import admin
from .models import  Booking, Service ,Payment# Import your models

admin.site.register(Booking)
admin.site.register(Service)
admin.site.register(Payment)

