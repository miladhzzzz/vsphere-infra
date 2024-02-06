from netmiko import ConnectHandler

switch = {
    "device_type": "cisco_ios",
    "host": "switch_ip_address",
    "username": "your_username",
    "password": "your_password",
}

# Establish SSH connection to switch
try:
    net_connect = ConnectHandler(**switch)
    print("Connected to switch successfully.")
except Exception as e:
    print("Failed to connect to switch:", str(e))
    exit()

# Configure DHCP
dhcp_config_commands = [
    "ip dhcp pool SERVERS",
    "network LAN_NETWORK mask LAN_NETMASK",
    "default-router ROUTER_IP_ADDRESS",
    "dns-server DNS_SERVER",
]
dhcp_config_output = net_connect.send_config_set(dhcp_config_commands)
print("DHCP configuration applied:", dhcp_config_output)

# Save configuration
save_output = net_connect.save_config()
print("Configuration saved:", save_output)

# Disconnect from switch
net_connect.disconnect()
print("Disconnected from switch.")
