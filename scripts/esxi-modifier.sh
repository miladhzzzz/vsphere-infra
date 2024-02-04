#!/bin/bash

# Check if required utilities are installed
check_dependencies() {
    if ! command -v mktemp > /dev/null; then
        echo "Error: mktemp is not installed. Please install it."
        exit 1
    fi

    if ! command -v hdiutil > /dev/null; then
        echo "Error: hdiutil is not installed. Please install it."
        exit 1
    fi

    if ! command -v ssh-keygen > /dev/null; then
        echo "Error: ssh-keygen is not installed. Please install it."
        exit 1
    fi

    if ! command -v sed > /dev/null; then
        echo "Error: sed is not installed. Please install it."
        exit 1
    fi
}

# Define variables
ESXI_IMAGE_FILE="$1"
SSH_PUBLIC_KEY_FILE="ssh_public_key.pub"
SSH_PRIVATE_KEY_FILE="ssh_private_key"
AUTOUNATTEND_FILE="autounattend.xml"
AUTOUNATTEND_OUTPUT="autounattend_output.xml"
DEFAULT_USERNAME="root"
MOUNT_DIR=$(mktemp -d)

# Function to mount the ESXi image
mount_esxi_image() {
    echo "Mounting the ESXi image..."
    hdiutil attach -mountpoint "$MOUNT_DIR" "$ESXI_IMAGE_FILE" || {
        echo "Failed to mount the ESXi image."
        exit 1
    }
}

# Function to generate SSH key pair
generate_ssh_key_pair() {
    echo "Generating SSH key pair..."
    ssh-keygen -t rsa -N "" -f "$SSH_PRIVATE_KEY_FILE" || {
        echo "Failed to generate SSH key pair."
        exit 1
    }
    echo "SSH key pair generated successfully."
}

# Function to inject SSH public key into ESXi image
inject_ssh_public_key() {
    echo "Injecting SSH public key into ESXi image..."
    mkdir -p "$MOUNT_DIR/etc/ssh/keys"
    cp "$SSH_PUBLIC_KEY_FILE" "$MOUNT_DIR/etc/ssh/keys/authorized_keys" || {
        echo "Failed to inject SSH public key into ESXi image."
        exit 1
    }
    echo "SSH public key injected successfully."
}

# Function to set up auto-installation options
setup_auto_installation() {
    echo "Setting up auto-installation options..."
    sed "s/{{USERNAME}}/$DEFAULT_USERNAME/g" "$AUTOUNATTEND_FILE" > "$MOUNT_DIR/$(basename $AUTOUNATTEND_OUTPUT)" || {
        echo "Failed to set up auto-installation options."
        exit 1
    }
    echo "Auto-installation options set up successfully."
}

# Function to unmount the ESXi image
unmount_esxi_image() {
    echo "Unmounting the ESXi image..."
    hdiutil detach "$MOUNT_DIR" || {
        echo "Failed to unmount the ESXi image."
        exit 1
    }
    echo "ESXi image unmounted successfully."
}

# Main function
main() {
    # Check if ESXi image file is provided
    if [ -z "$ESXI_IMAGE_FILE" ]; then
        echo "Usage: $0 <path_to_esxi_image>"
        exit 1
    fi

    # Check if required utilities are installed
    check_dependencies

    # Mount the ESXi image
    mount_esxi_image

    # Generate SSH key pair
    generate_ssh_key_pair

    # Inject SSH public key into ESXi image
    inject_ssh_public_key

    # Set up auto-installation options
    setup_auto_installation

    # Unmount the ESXi image
    unmount_esxi_image

    echo "ESXi image customization complete."
}

# Call main function
main
