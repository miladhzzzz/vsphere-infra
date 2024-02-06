from netmiko import ConnectHandler

router = {
    "device_type": "cisco_ios",
    "host": "router_ip_address",
    "username": "your_username",
    "password": "your_password",
}

# Establish SSH connection to router
try:
    net_connect = ConnectHandler(**router)
    print("Connected to router successfully.")
except Exception as e:
    print("Failed to connect to router:", str(e))
    exit()

# Configure BGP
bgp_config_commands = [
    "router bgp YOUR_ASN",
    "neighbor WAN_IP_ADDRESS remote-as PEER_ASN",
    "network LAN_NETWORK mask LAN_NETMASK",
]
bgp_config_output = net_connect.send_config_set(bgp_config_commands)
print("BGP configuration applied:", bgp_config_output)

# Save configuration
save_output = net_connect.save_config()
print("Configuration saved:", save_output)

# Disconnect from router
net_connect.disconnect()
print("Disconnected from router.")
