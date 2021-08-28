from django.urls import path
from api.views import (registration_view, product)
from rest_framework.authtoken import views

app_name = "api"

urlpatterns = [
    path('account/register', registration_view, name="register"),
    path('product', product, name="product"),
]

# urlpatterns += [
#     path('api-token-auth/', views.obtain_auth_token)
# ]
