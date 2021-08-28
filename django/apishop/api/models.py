from django.db import models
from django.contrib.auth.models import User
from apishop.models import MyUser

#   final String id;
#   final String title;
#   final String description;
#   final double price;
#   final String imageUrl;
#   bool isFavorite;


class Product(models.Model):
    title = models.CharField(max_length=100)
    description = models.CharField(max_length=300)
    price = models.CharField(max_length=50)
    image = models.ImageField(upload_to='files/product', blank=True)
    isfavorite = models.BooleanField(default=False)

    class Meta:
        verbose_name = 'Product'
        verbose_name_plural = 'Product'

    def __str__(self):
        return self.title
