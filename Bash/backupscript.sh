#!/bin/bash
# --------------------
# Global variables
# --------------------
margs=1
margs_check=0
backup_directory=""
datetime=$(date +"%F")
backup_name="backup.${datetime}.tar.gz"


# --------------------
# Functions
# --------------------
function usage {
	echo -e "WRONG INPUT:\nMANDATORY\n\t-d <Directory to backup>\nOPTIONAL\n\t-f <backup filename>"
}


function margs_check {
	if [ $margs_check -lt $margs ]; then
		usage
		exit 1
	fi
}


# --------------------
# Get parameters
# --------------------
while getopts d:f: flag; do
	case "${flag}" in
		d) 
			backup_directory=${OPTARG}
			margs_check+=1
		;;
		f) 
			backup_name=${OPTARG}
		;;
		*) 
			usage
			exit 1
		;;
	esac
done
margs_check


# --------------------
# Create backup
# --------------------
# c=create backup archive, v=verbose mode, p=preserve permissions, z=compress backup, f=filename
tar -cvpzf "$backup_name" "$backup_directory"


# --------------------
# Add or create crontab
# --------------------
# Check if crontab exists
crontab -l >> crontab.value.temp

# Create new crontab if none exists
if [ $? -ne 0 ]; then
	echo "Creating new crontab..."
	touch cron
	echo "0 17 * * 6 /root/Network-Scripting/Network_Scripting/Bash/backupscript.sh" >> cron
	crontab cron
	rm -f cron
else
	grep -q "backupscript.sh" crontab.value.temp
	# Check if cron for backupschript allready exixts
	if [ $? -ne 0 ]; then
		echo "0 17 * * 6 /root/Network-Scripting/Network_Scripting/Bash/backupscript.sh" >> crontab.value.temp
		echo "test"
		crontab crontab.value.temp
	fi	
fi	
rm -f crontab.value.temp
exit 0 
