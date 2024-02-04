#!/bin/bash

docker build -t ipxe-server .
docker run -d --name ipxe-server -v /path/to/iso:/tftpboot/ipxe_files -p 69:69/udp ipxe-server
