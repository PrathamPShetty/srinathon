from django.db import models
from django.contrib.auth.models import User


class Service(models.Model):
    name = models.CharField(max_length=255, null=True)
    description = models.TextField(null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    price = models.DecimalField(max_digits=10, decimal_places=2, null=True)

    def __str__(self):
        return self.name


class Booking(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    service = models.ForeignKey(Service, on_delete=models.CASCADE)
    additional_service = models.CharField(max_length=50, null=True)
    orderID = models.TextField(null=True)
    call = models.CharField(max_length=100)
    time = models.TimeField()
    date = models.DateField()
    notification = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.service.name} booking by {self.user.username} on {self.date} at {self.time}"

class Payment(models.Model):
    bookingID =  models.ForeignKey(Booking, on_delete=models.CASCADE)
    order_id = models.CharField(max_length=255)
    payment_id = models.CharField(max_length=255, null=True, blank=True)
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    status = models.CharField(max_length=50, choices=[("created", "Created"), ("captured", "Captured")])
    service = models.ForeignKey(Service, on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
