from django.contrib import admin
from .models import Customer, Service, Booking  # Import your models

# Custom admin class for Customer model
class CustomerAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'email', 'phone_number', 'created_at')
    search_fields = ('first_name', 'last_name', 'email')
    list_filter = ('created_at',)
    ordering = ('-created_at',)

# Custom admin class for Service model
class ServiceAdmin(admin.ModelAdmin):
    list_display = ('name', 'worker', 'price', 'availability')
    search_fields = ('name', 'worker')
    list_filter = ('availability',)
    ordering = ('name',)

# Custom admin class for Booking model
class BookingAdmin(admin.ModelAdmin):
    list_display = ('service', 'call', 'date', 'time', 'notification')
    search_fields = ('service', 'call')
    list_filter = ('service', 'date', 'notification')
    ordering = ('-date', 'time')

# Register models with their respective admin classes
admin.site.register(Customer, CustomerAdmin)
admin.site.register(Service, ServiceAdmin)
admin.site.register(Booking, BookingAdmin)
