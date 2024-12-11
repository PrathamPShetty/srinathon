from django.contrib import admin
from django.urls import path
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)
from .views import BookingView,create_order, ServiceListView, UserListView,OrderView


urlpatterns = [
  path('token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
  path('token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),


  path('services/', ServiceListView.as_view(), name='service-list'),
  path('users/', UserListView.as_view(), name='user-list'),

  path('bookings/', BookingView.as_view(), name='booking'),
  path('orders/', OrderView.as_view(), name='order'),


  path("payments/create-order/", create_order, name="create_order"),

]


