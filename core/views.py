# core/views.py

from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken
# Importa a exceção específica
from rest_framework_simplejwt.exceptions import TokenError
from django.contrib.auth import get_user_model
from .serializers import UserRegistrationSerializer, UserSerializer, UserPrivateSerializer

User = get_user_model()


class RegisterView(APIView):
    permission_classes = (AllowAny,)

    def post(self, request):
        serializer = UserRegistrationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Usuário registrado com sucesso."}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CustomTokenObtainPairView(TokenObtainPairView):
    permission_classes = (AllowAny,)


class LogoutView(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        try:
            # Pega o refresh token do corpo da requisição
            refresh_token = request.data["refresh_token"]
            token = RefreshToken(refresh_token)
            # Adiciona o token à blacklist
            token.blacklist()
            return Response({"message": "Logout realizado com sucesso."}, status=status.HTTP_205_RESET_CONTENT)
        except KeyError:
            # Captura o erro se 'refresh_token' não for enviado
            return Response({"detail": "O campo 'refresh_token' é obrigatório."}, status=status.HTTP_400_BAD_REQUEST)
        except TokenError:
            # Captura o erro se o token for inválido ou já estiver na blacklist
            return Response({"detail": "Token inválido ou expirado."}, status=status.HTTP_400_BAD_REQUEST)


class UserDetailView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request, pk):
        try:
            user = User.objects.get(pk=pk)
            # Idealmente, você não deveria permitir que qualquer usuário logado veja os dados de outro
            # Considere adicionar uma verificação: if user == request.user or request.user.is_staff:
            serializer = UserSerializer(user)
            return Response(serializer.data)
        except User.DoesNotExist:
            return Response({"detail": "Usuário não encontrado."}, status=status.HTTP_44_NOT_FOUND)


class MyUserView(APIView):
    permission_classes = (IsAuthenticated,)

    def get(self, request):
        # Retorna os dados do próprio usuário logado
        serializer = UserPrivateSerializer(request.user)
        return Response(serializer.data)
