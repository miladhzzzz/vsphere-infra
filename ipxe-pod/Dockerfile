# Use a lightweight base image
FROM alpine:latest

# Install required packages
RUN apk update && \
    apk add --no-cache ipxe

# Create a directory to store iPXE configuration files
RUN mkdir -p /tftpboot

# Copy your iPXE configuration files to the container
COPY ipxe_files/* /tftpboot/

# Expose the necessary port for TFTP
EXPOSE 69/udp

# Run a simple TFTP server
CMD ["ipxe", "-d", "TFTP", "-H", "/tftpboot"]
