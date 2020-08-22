FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
WORKDIR /app


# Copy csproj and restore as distinct layers
RUN apt install -y git && \
    git clone https://github.com/Elepover/pmcenter.git && \
    cd /app/pmcenter/pmcenter && \
    dotnet restore -v m && \
    dotnet publish pmcenter.csproj -c Release -o /app/out --self-contained false && \
    cp /app/pmcenter/locales/pmcenter_locale_zh.meow.json /app/out/pmcenter_locale.json

# Build runtime image
FROM mcr.microsoft.com/dotnet/core/runtime:3.1-alpine
WORKDIR /app
COPY --from=build-env /app/out .

ENTRYPOINT ["dotnet", "pmcenter.dll"]