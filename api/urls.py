from django.contrib import admin
from django.urls import path
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .views import BookingView,create_order, ServiceListView


urlpatterns = [
  path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
  path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),


  path('services/', ServiceListView.as_view(), name='service-list'),

  path('api/bookings/', BookingView.as_view(), name='booking'),


  path("api/payments/create-order/", create_order, name="create_order"),

]


