#!/bin/bash
# --------------------
# Global variables
# --------------------
conf_file_path="/etc/dhcp/dhcpd.conf" 
input_file_path=


# --------------------
# Functions
# --------------------
function usage {
    echo -e "This script needs exactly 1 argument\ncreate-dhcp-ranges.sh <path-to-input-file>:"
}

function write_conf_file {
    grep -q "subnet $network_address netmask $subnetmask" $conf_file_path
    if [[ $? -ne 0 ]]; then
	echo -e "subnet $network_address netmask $subnetmask {" >> $conf_file_path
	echo -e "range $range_start $range_stop;" >> $conf_file_path
	echo -e "}" >> $conf_file_path
    else
	sed -i "/^subnet $network_address netmask $subnetmask/a range $range_start $range_stop;" $conf_file_path
    fi
}


# --------------------
# Check positional parameter
# --------------------
if [[ $# -ne 1 ]]; then
    usage;	
    exit 1
else
    input_file_path=$1
fi


# --------------------
# Create backup
# --------------------
cp -f $conf_file_path /tmp/backup.dhcpd.conf


# --------------------
# Read input file
# --------------------
tail -n 1 $input_file_path > tempinput 
while IFS= read -r line
do
    network_address=$(awk -F ';' '{print $1}' tempinput)
    subnetmask=$(awk -F ';' '{print $2}' tempinput)
    range_start=$(awk -F ';' '{print $3}' tempinput)
    range_stop=$(awk -F ';' '{print $4}' tempinput)
    write_conf_file
done < tempinput
rm -f tempinput
