#!/bin/bash
# --------------------
# Global variables
# --------------------
interface=$1
config_path="/etc/network/interfaces"
static_address="192.168.1.5/24"
static_gateway="192.168.1.1"
seconds_date=$(date +'%s')


# --------------------
# Create backup of interfaces file
# --------------------
cp $config_path $config_path.$seconds_date.back


# --------------------
# Check if interface exists
# --------------------
ip a | grep -q $interface
if [[ $? -ne 0 ]]; then
	echo "Interface does not exists!"
	exit 1
fi


# --------------------
# Check if current config is static or dynamic
# --------------------
grep -q "iface $interface inet dhcp" $config_path
is_dhcp=$?


# --------------------
# Set config to static if current is dynamic
# --------------------
if [[ $is_dhcp -eq 0 ]]; then
	echo "Configuration is dynamic and will be set to static!"

	# Add commands
	sed -i "s/inet dhcp/inet static/" $config_path
	echo -e "\taddress $static_address" >> $config_path
	echo -e "\tgateway $static_gateway" >> $config_path
fi


# --------------------
# Set config to dynamic if set to static
# --------------------
if [[ $is_dhcp -ne 0 ]]; then
	echo "Configuration is static and will be set to dynamic!"

	# Add commands
	sed -i "s/inet static/inet dhcp/" $config_path
	sed -i "/address/d" $config_path
	sed -i "/gateway/d" $config_path
fi


# --------------------
# restart service
# --------------------
systemctl restart networking.service
restart_ok=$?
if [[ $restart_ok -eq 0 ]]; then
	echo "Network service restarted succesfully"
	rm -f $config_path.$seconds_date.back
	exit $restart_ok
else 
	echo "Network service could not be restarted due to errors! There is a backupfile made in /etc/network/."
	exit $restart_ok
fi
