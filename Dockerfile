# Imagen base para la aplicación en tiempo de ejecución
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Etapa de compilación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar solo el archivo de proyecto para restaurar dependencias
COPY backend.csproj ./
RUN dotnet restore "backend.csproj"

# Copiar todo el código fuente
COPY . . 

# Definir configuración de compilación (por defecto Release)
ARG BUILD_CONFIGURATION=Release
RUN dotnet build "backend.csproj" -c $BUILD_CONFIGURATION -o /app/build

# Etapa de publicación
FROM build AS publish
RUN dotnet publish "backend.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# Imagen final con la aplicación publicada
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Definir el punto de entrada
ENTRYPOINT ["dotnet", "backend.dll"]

