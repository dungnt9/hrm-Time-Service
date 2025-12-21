FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["TimeService.csproj", "."]
RUN dotnet restore "TimeService.csproj"
COPY . .
RUN dotnet build "TimeService.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TimeService.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENV ASPNETCORE_URLS="http://+:8080;http://+:8081"
ENTRYPOINT ["dotnet", "TimeService.dll"]
