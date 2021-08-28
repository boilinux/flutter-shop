from django.contrib import admin
from api.models import Product
from rest_framework.authtoken.admin import TokenAdmin

# Register your models here.
admin.site.register(Product)
TokenAdmin.raw_id_fields = ['user']
