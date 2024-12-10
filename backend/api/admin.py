from django.contrib import admin
from .models import CustomUser, Service, Booking  # Import your models

admin.site.register(CustomUser)
admin.site.register(Service)
admin.site.register(Booking)



# class CustomerAdmin(admin.ModelAdmin):
#     list_display = ('first_name', 'last_name', 'email', 'phone_number', 'created_at')
#     search_fields = ('first_name', 'last_name', 'email')
#     list_filter = ('created_at',)
#     ordering = ('-created_at',)

# # Custom admin class for Service model
# class ServiceAdmin(admin.ModelAdmin):
#     list_display = ('name', 'worker', 'price', 'availability')
#     search_fields = ('name', 'worker')
#     list_filter = ('availability',)
#     ordering = ('name',)

# # Custom admin class for Booking model
# class BookingAdmin(admin.ModelAdmin):
#     list_display = ('service', 'call', 'date', 'time', 'notification')
#     search_fields = ('service', 'call')
#     list_filter = ('service', 'date', 'notification')
#     ordering = ('-date', 'time')

