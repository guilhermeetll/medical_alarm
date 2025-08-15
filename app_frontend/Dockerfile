# Stage 1: Build the Flutter web app
FROM debian:latest AS build

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    wget \
    && apt-get clean

# Install Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Enable web support
RUN flutter config --enable-web

# Set working directory
WORKDIR /app

# Copy pubspec files from alarm_care_pro subdirectory
COPY alarm_care_pro/pubspec.* ./

# Get dependencies
RUN flutter pub get

# Copy the rest of the Flutter project files
COPY alarm_care_pro ./

# Build the web app
RUN flutter build web

# Stage 2: Serve the web app
FROM nginx:alpine

# Copy the built web app to nginx
COPY --from=build /app/build/web /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
