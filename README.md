
CHANGES
-------
v0.3	21 Aug 2020, Latest Google browser support Initial public release.

Requirement to run this program
-------------------------------

1. Unix system that can run "sh". I prefer Linux. But I write this on
   CentOS 8 due to work requirement. Yes, it runs on Linux.

2. Working openssl 0.9.4 or above. I am using 1.1.1u. Yes, it runs on Linux.

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




6. Package the user certificate into a single pkcs12 file.



# ./p12.sh 
Usage: ./p12.sh user@email.address.com
# ./p12.sh yeak@192.168.0.12
Enter Export Password:
Verifying password - Enter Export Password:

The certificate for yeak@192.168.0.12 has been collected into a pkcs12 file.
You can download to your browser and import it.



7. DONE!



PROBLEM SOLVING
---------------
I am sure you have problem to even using the script. Yes, I actually need
to improve them first. But see the following first (I know, I know...)

Q. "openssl" not found?

A. You need to have openssl 0.9.4 in your machine. For Red Hat Linux, just
   install the openssl-xxxx.rpm package. On Solaris, make sure your PATH
   environment is set correctly. In my case, I have openssl installed in
   /usr/local/ssl/bin/openssl. So I need to make sure my PATH contain
   "/usr/local/ssl/bin" and export the this PATH variable.

Q. warning, not much extra random data, consider using the -rand option
   14044:error:20.......................... PRNG not seeded:md_rand.c

A. In openssl 0.9.5a version, the random seed (PRNG) is important in order to
   generate any private key. This is a security feature, not a bug. In
   my kit, I actually include the random-bits that I make up. Do not simply
   use it! You should try to modify the "new-root-ca.sh" file, look for
   "-rand random-bits", change it to "-rand /var/adm/wtmpx:/var/adm/messages"
   in order to get your own unique seed. Note, once you successfully make
   the openssl run, it will create a $HOME/.rnd file for future use.

   In Linux, you can use "-rand /dev/urandom". If you use
   "-rand /dev/random", be sure to patiently wait until it start to generate
   something... :-)

Q. where should I install ssl.ca directory?

A. You can put anywhere. I put inside /usr/local/apache/conf where I have
   ssl.key, ssl.crt, ssl.csr... around.

Q. I can't important the p12 files to my Mac or PC!

A. Make sure the file is downloaded as "binary". Windows NT 4 might have
   problem to read the key. Try Windows 2000 or Windows 98.


TODO
----
Web based certificate management. Need a lot of input from all of you out
there.

