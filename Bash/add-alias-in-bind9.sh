
#!/bin/bash
# --------------------
# Global variables
# --------------------
conf_file_path="/etc/bind/zones/intranet.mijnschool.be.db" 


# --------------------
# Functions
# --------------------
function usage {
    echo -e "This script needs minimum one parameter:\nadd-alias-to-bind9.sh <name of website> [name of website]..."
}

function add-alias {
    echo "$1 IN CNAME intranet.mijnschool.be." >> $conf_file_path
}

# --------------------
# Check positional parameters
# --------------------
if [[ $# -lt 1 ]]; then
    usage;	
    exit 1
else
    for par in $@; do
	add-alias $par
    done
    /etc/init.d/bind9 restart
    exit $?
fi

