from django.db.models import fields
from rest_framework import serializers
from apishop.models import MyUser
from api.models import Product


class RegistrationSerializer(serializers.ModelSerializer):
    password2 = serializers.CharField(
        style={'input_type': 'password'}, write_only=True)
    user_account = serializers.StringRelatedField(many=True)

    class Meta:
        model = MyUser
        fields = ['email', 'date_of_birth', 'phone_number',
                  'password', 'password2', 'user_account']
        extra_kwargs = {
            'password': {'write_only': True}
        }

    def save(self):
        account = MyUser(
            email=self.validated_data['email'],
            date_of_birth=self.validated_data['date_of_birth'],
            phone_number=self.validated_data['phone_number'],
        )

        password = self.validated_data['password']
        password2 = self.validated_data['password2']

        if password != password2:
            raise serializers.ValidationError(
                {'password': 'Password must match.'})

        account.set_password(password)
        account.save()

        return account


class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'
