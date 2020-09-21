#!/bin/sh
##
##  new-root-ca.sh - create the root CA
##  Copyright (c) 2000 Yeak Nai Siew, All Rights Reserved. 
##  Google Chrome Support Modified by Govind Sharma <Govind.sharma@flexydial.com>
##

blink='\e[5m'
g='\e[38;5;82m'
r='\e[1;31;47m'
c='\e[0m'

# Create the master CA key. This should be done once.
if [ ! -f ca.key ]; then
    echo ""
	echo -e "$g No Root CA key round. Generating CA.key file"
	echo ""
	echo -e "$r Enter Strong Password for CA $c"
	echo ""
	openssl genrsa -des3 -out ca.key 4096
	echo ""
fi

# Self-sign it.
CONFIG="root-ca.conf"
cat >$CONFIG <<EOT
[ req ]
default_bits			= 4096
default_keyfile			= ca.key
distinguished_name		= req_distinguished_name
x509_extensions			= v3_ca
string_mask			= nombstr
req_extensions			= v3_req
[ req_distinguished_name ]
countryName			= Country Name (2 letter code)
countryName_default		= MY
countryName_min			= 2
countryName_max			= 2
stateOrProvinceName		= State or Province Name (full name)
stateOrProvinceName_default	= Perak
localityName			= Locality Name (eg, city)
localityName_default		= Sitiawan
0.organizationName		= Organization Name (eg, company)
0.organizationName_default	= My Directory Sdn Bhd
organizationalUnitName		= Organizational Unit Name (eg, section)
organizationalUnitName_default	= Certification Services Division
commonName			= Common Name (eg, MD Root CA)
commonName_max			= 64
emailAddress			= Email Address
emailAddress_max		= 40
[ v3_ca ]
basicConstraints		= critical,CA:true
subjectKeyIdentifier		= hash
[ v3_req ]
nsCertType			= objsign,email,server
EOT

echo -e "$g Generating Self-sign the root CA$blink...$c"
echo ""
openssl req -new -x509 -days 3650 -config $CONFIG -key ca.key -out ca.crt

rm -f $CONFIG
echo -e "$g You Have Successfully Generated CA Certificates$c"
echo ""
echo -e "CA Key         = $g ca.key$c"
echo -e "CA Certificate = $g ca.crt$c"
echo ""
