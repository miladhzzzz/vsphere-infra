from netmiko import ConnectHandler

router = {
    "device_type": "cisco_ios",
    "host": "sandbox-iosxe-latest-1.cisco.com",
    "username": "developer",
    "password": "C1sco12345",
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
    "configure terminal",
    "show inet",
    "",
]
bgp_config_output = net_connect.send_config_set(bgp_config_commands)
print("BGP configuration applied:", bgp_config_output)

# Save configuration
save_output = net_connect.save_config()
print("Configuration saved:", save_output)

# Disconnect from router
net_connect.disconnect()
print("Disconnected from router.")
