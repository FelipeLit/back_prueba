# Imagen base para la aplicación en tiempo de ejecución
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Etapa de compilación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar archivos del proyecto y restaurar dependencias
COPY backend.csproj backend/
RUN dotnet restore "backend.csproj"

# Copiar el resto del código fuente y compilar
COPY . .
WORKDIR "/src/backend"

# Definir configuración de compilación con un argumento (por defecto Release)
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
