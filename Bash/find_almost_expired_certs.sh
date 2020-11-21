# Find all certificates
find /etc/ssl/certs/ -name "*.pem" >> /tmp/.certificates.tmp

# Read all certificates and check them
while IFS= read -r line
do
    # Check if certificate expires in 2 weeks
    openssl x509 -enddate -noout -in $line -checkend 1209600 | grep -q "Certificate will expire"
    if [[ $? -eq 0 ]]; then
        echo "Certificate $line will expire in the next 14 days"
    fi
done < /tmp/.certificates.tmp
rm -f /tmp/.certificates.tmp
