# SSL-Create-localdomain
SSL certifiates create for local server


CHANGES
-------
v0.3	21 Aug 2020, Google browser suppot Initial public release.

This README file will explain how to use this handy "kit" to get your
certificate creation and signing task easier using openssl. You can also
modify the scripts to suit your needs.

Requirement to run this program
-------------------------------

1. Unix system that can run "sh". I prefer Linux. But I write this on
   CentOS-8-core due to work requirement. Yes, it runs on Linux.

2. Working openssl 0.9.4 or latest. I am using 1.1.1c. Yes, it runs on Linux.

To test the certification, you need,

1. Web Server that use the server certificate


How to use it
-------------

The script is written based on this concept:

1. You have one self-signed Root Certificate (Root CA) that is used to
   sign everything that you are going to generate.
2. You can generate the web server cert for Apache+Mod-SSL to use.
3. You can generate S/MIME key for your Netscape browser to use.

To start, you must create a self-signed Root Certification Authority.
This is done by running "new-root-ca.sh". Remember the password of this
key.

You run "new-server-cert.sh" to create a web server's private and
public key. The script will continue on to enter the ceritificate information.
We call this "certificate signing request (csr)". The format is x509. You
need to run "sign-server-cert.sh" to approve and sign with your root key.

You run "new-user-cert.sh" to create a user certificate. You can use this
to sign and encrypt your email using MS Outlook Express or Netscape browser.
You need to run "sign-user-cert.sh" to sign it.

I hope the explaination is very straight forward.

Example Usage
-------------


1. Create the self-signed Root CA key


# ./new-root-ca.sh 
No Root CA key round. Generating one
Generating RSA private key, 1024 bit long modulus
....++++++
.............++++++
e is 65537 (0x10001)
Enter PEM pass phrase:
Verifying password - Enter PEM pass phrase:

Self-sign the root CA...
Using configuration from root-ca.conf
Enter PEM pass phrase:
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [MY]:
State or Province Name (full name) [Perak]:
Locality Name (eg, city) [Sitiawan]:
Organization Name (eg, company) [My Directory Sdn Bhd]:
Organizational Unit Name (eg, section) [Certification Services Division]:
Common Name (eg, MD Root CA) []:MD Root CA
Email Address []:Default@default.com



2. Create the server cert


# ./new-server-cert.sh 
Usage: ./new-server-cert.sh <www.domain.com>
# ./new-server-cert.sh 192.168.0.12
No 192.168.0.12.key round. Generating one
Generating RSA private key, 1024 bit long modulus
...++++++
......++++++
e is 65537 (0x10001)

Fill in certificate data
Using configuration from server-cert.conf
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [MY]:
State or Province Name (full name) [Perak]:    
Locality Name (eg, city) [Sitiawan]:
Organization Name (eg, company) [My Directory Sdn Bhd]:
Organizational Unit Name (eg, section) [Secure Web Server]:
Common Name (eg, www.domain.com) []:192.168.0.12
Email Address []:NA

You may now run ./sign-server-cert.sh 192.168.0.12 to get it signed



3. Sign the server cert


# ./sign-server-cert.sh 
Usage: ./sign-server-cert.sh <www.domain.com>
# ./sign-server-cert.sh 192.168.0.12
CA signing: 192.168.0.12.csr -> 192.168.0.12.crt:
Using configuration from ca.config
Enter PEM pass phrase:
Check that the request matches the signature
Signature ok
The Subjects Distinguished Name is as follows
countryName           :PRINTABLE:'IN'
stateOrProvinceName   :PRINTABLE:'MU'
localityName          :PRINTABLE:'Mumbai'
organizationName      :PRINTABLE:'Your company name'
organizationalUnitName:PRINTABLE:'Your company unit name'
commonName            :PRINTABLE:'192.168.0.12'
emailAddress          :IA5STRING:'NA'
Certificate is to be certified until Apr 24 12:43:27 2001 GMT (365 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
CA verifying: 192.168.0.12.crt <-> CA cert
192.168.0.12.crt: OK



4. Create the user cert


# ./new-user-cert.sh 
Usage: ./new-user-cert.sh user@email.address.com
# ./new-user-cert.sh 192.168.0.12
No 192.168.0.12.key round. Generating one
Generating RSA private key, 1024 bit long modulus
....................++++++
............++++++
e is 65537 (0x10001)

Fill in certificate data
Using configuration from user-cert.conf
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Common Name (eg, John Doe) []:IN    
Email Address []:NA

You may now run ./sign-user-cert.sh 192.168.0.12 to get it signed



5. Sign the user cert


# ./sign-user-cert.sh     
Usage: ./sign-user-cert.sh user@email.address.com
# ./sign-user-cert.sh 192.168.0.12
CA signing: 192.168.0.12.csr -> 192.168.0.12.crt:
Using configuration from ca.config
Enter PEM pass phrase:
Check that the request matches the signature
Signature ok
The Subjects Distinguished Name is as follows
commonName            :PRINTABLE:'IN'
emailAddress          :IA5STRING:'CA-IN'
Certificate is to be certified until Apr 24 12:53:58 2001 GMT (365 days)
Sign the certificate? [y/n]:y


1 out of 1 certificate requests certified, commit? [y/n]y
Write out database with 1 new entries
Data Base Updated
CA verifying: 192.168.0.12.crt <-> CA cert
192.168.0.12.crt: OK

TODO
----
Web based certificate management. Need a lot of input from all of you out
there.

