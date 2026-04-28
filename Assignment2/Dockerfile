# Build stage
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# copy csproj and restore as distinct layers for better caching
COPY *.csproj ./
RUN dotnet restore "Assignment2.csproj"

# copy everything else and publish
COPY . .
RUN dotnet publish "Assignment2.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app

# bind to port 80 inside the container
ENV ASPNETCORE_URLS=http://+:80
COPY --from=build /app/publish .

EXPOSE 80

ENTRYPOINT ["dotnet", "Assignment2.dll"]