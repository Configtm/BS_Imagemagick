FROM debian:bookworm

ENV http_proxy="http://192.168.100.100:3128/"
ENV https_proxy="http://192.168.100.100:3128/"
ENV no_proxy="localhost,127.0.0.1"

# Set workdir where script will be copied
WORKDIR /app

# Copy startup.sh from host into container
COPY startup.sh test_imagemagick.sh /app/

# Optional: Install anything ImageMagick or shell depends on
RUN apt update && apt install -y bash

# Make sure the script is executable
RUN chmod +x startup.sh /app/test_imagemagick.sh

# Default command if not overridden by docker-compose
CMD ["./startup.sh ./test_imagemagick.sh"]
