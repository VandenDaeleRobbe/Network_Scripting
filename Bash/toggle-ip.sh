#!/bin/bash
# --------------------
# Global variables
# --------------------
interface=$1
config_path="/etc/network/interfaces"


# --------------------
# Create backup of interfaces file
# --------------------
cp $config_path ~/interfaces.back


# --------------------
# Check if interface exists
# --------------------
ip a | grep $interface
if [[ $? -ne 0 ]]; then
	echo "Interface does not exists!"
	exit 1
fi


# --------------------
# Check if current config is static or dynamic
# --------------------
cat $config_path | grep "iface $interface inet dhcp"
is_dhcp=$?

rm -f $config_path # Remove current config file
touch $config_path # Create config file

# Add loopback
echo "iface lo inet loopback" >> $config_path
echo "auto lo" >> $config_path
echo "" >> $config_path


# --------------------
# Set config to static if current is dynamic
# --------------------
if [[ $is_dhcp -eq 0 ]]; then
	echo "Configuration is dynamic and will be set to static!"

	# Add commands
	echo "auto $interface" >> $config_path
	echo "iface $interface inet static" >> $config_path	
	echo -e "\taddress 192.168.1.5/24" >> $config_path
	echo -e "\tgateway 192.168.1.1" >> $config_path
fi


# --------------------
# Set config to dynamic if set to static
# --------------------
if [[ $is_dhcp -ne 0 ]]; then
	echo "Configuration is static and will be set to dynamic!"

	# Add commands
	echo "auto $interface" >> $config_path
	echo "iface $interface inet dhcp" >> $config_path	
fi


# --------------------
# restart service
# --------------------
systemctl restart networking.service
exit $?
