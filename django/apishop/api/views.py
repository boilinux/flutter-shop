from rest_framework import status
from rest_framework.response import Response
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.authentication import TokenAuthentication, SessionAuthentication, BasicAuthentication
from django.http import HttpResponse, JsonResponse
from api.serializers import (
    RegistrationSerializer, ProductSerializer
)
from api.models import Product

# Create your views here.


@api_view(['POST'])
@authentication_classes([SessionAuthentication, BasicAuthentication])
@permission_classes([IsAuthenticated])
def registration_view(request):
    if request.method == 'POST':
        serializer = RegistrationSerializer(data=request.data)
        data = {}

        if serializer.is_valid():
            account = serializer.save()
            data['response'] = "Successfully registered a new user."
            data['email'] = account.email
        else:
            data = serializer.errors

        return Response(data)


@api_view(['POST', 'GET'])
@authentication_classes([TokenAuthentication])
# @authentication_classes([SessionAuthentication, BasicAuthentication])
@permission_classes([IsAuthenticated])
def product(request):
    if request.method == 'POST':
        serializer = ProductSerializer(data=request.data)
        data = {}

        if serializer.is_valid():
            serializer.save()
            data['response'] = "Successfully Added Product."
            data['data'] = serializer.data
        else:
            data = serializer.errors

        return Response(data)

    if request.method == 'GET':
        product = Product.objects.all()
        serializer = ProductSerializer(product, many=True)
        return Response(serializer.data)
