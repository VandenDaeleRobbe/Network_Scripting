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
# Functions`
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
