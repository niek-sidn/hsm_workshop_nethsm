-----------------------------
## PKCS#11 (part 1)
PKCS#11 is a Public-Key Cryptography Standard that **defines a programming interface** to create and
manipulate cryptographic tokens.  
Also known as "Cryptoki".
[PKCS#11 illustrated](https://github.com/tpm2-software/tpm2-pkcs11/blob/master/docs/illustrations/pkcs11_api_classification.png)  
Most (all?) HSMs implement a PKCS#11 API. This means there is a very good chance PKCS#11 can be used to talk to an HSM.

Linuxes have the ***opensc*** package that contains the pksc11-tool for use on the cli.  
**Please note:** HSMs implement a PKCS#11 API, but also often offer vendor specific tools (like e.g. softhsm2-util), and/or a HTTP based interface (could also be an API). This means you often can accomplish things in  more than one way.

As an illustration: these 3 commands against a Nitrokey NetHSM have the "same" output:
``` bash
pkcs11-tool --module $SO_NETHSM --show-info
nitropy nethsm --no-verify-tls --host $NETHSM_PUB_IPV4:32768 info
curl $CURLOPTS $API/info | jq .
# And even:
softhsm2-util --module $SO_NETHSM --show-slots  # you can use softhsm2-util with a different HSM!
```

**Also note:** The pksc11-tool from the opensc package is mostly functional, but the version number "0.25" does communicate something.  
[OpenSC on GitHub](https://github.com/OpenSC/OpenSC)  
I ran into some issues with version 0.22/0.23, but 0.25 is fine.  

[List of PKCS#11 enabled software (that used to be) on Wikipedia](https://web.archive.org/web/20240405121602/https://en.wikipedia.org/wiki/List_of_applications_using_PKCS_11#expand)  
Important to us: OpenDNSSEC, BIND, PowerDNS and Knot are all on the list.  
All the software on the list should in principle be able to talk to an HSM.  
Either as a client or as a server, either directly or via some plug-in or middleware.  
E.g. Firefox, OpenVPN, OpenSSL, OpenSSH, Oracle DB, Gnome Keyring, Nginx, Apache2.  
Lots of programming languages have a library for PKCS11.
``` python
import os, pkcs11, base64
token = pkcs11.lib(os.environ['SO_SOFTHSM']).get_token(token_label='Token1')
with token.open(user_pin='0000') as session:
    key = session.generate_key(pkcs11.KeyType.AES, key_length=256)
    iv = session.generate_random(128)
    crypttext = key.encrypt(b'Look mum I can do AES!', mechanism_param=iv)
print(base64.b64encode(iv).decode(),base64.b64encode(crypttext).decode())
```

**All of PKCS#11 works via a library/"driver" (.dll or .so) often called
"Module".**  
The environment variables SO_SOFTHSM and SO_NETHSM above are paths to such .so libs  
`export SO_SOFTHSM="/usr/lib/softhsm/libsofthsm2.so"`  
`export SO_NETHSM="/usr/local/lib/nethsm/nethsm-pkcs11-vv1.6.0-x86_64-ubuntu.24.04.so"`  
`export SO_KRYOPTIC="/usr/lib/x86_64-linux-gnu/pkcs11/libkryoptic_pkcs11.so"`  

-----------------
## Exercise "Introducing pkcs11-tool from opensc package & hash"
OpenCS is below version 1, but good enough for this
workshop. Note: man file is not yet completely helpful, and examples 
on the interwebs are often confusing.

``` bash
sudo apt install opensc xxd openssl
(sudo) pkcs11-tool --module /usr/lib/softhsm/libsofthsm2.so --show-info
# also try one of the other HSMs, use the SO_ environment vars if you are tired of typing
# Linux bash: tab expansion works on $SO_...
```

-----------
``` bash
(sudo) pkcs11-tool --module $SO_SOFTHSM --list-slots
```
If run as root it shows all slots of all users, but if run as non-root, pkcs11-tool shows only your own tokens)  
Also try the other HSMs, Hint: Kryoptic differs, what happened?

Let's correct this:
``` bash
pkcs11-tool --module $SO_KRYOPTIC --init-token --label Token1
# enter 1234 as so_pin (twice)
pkcs11-tool --module $SO_KRYOPTIC --token Token1 --init-pin --login
# enter the so_pin (1234) as Security Officer authentication
# enter 0000 (twice) to set the operator pin
# Please note that Kryoptic depends on an env variable KRYOPTIC_CONF=/root/token.sql
#   it should contain a path to a non-existing file or an existing kryoptic sqlite database
```

------------------

#### HSMs report their capabilities:
```
pkcs11-tool --module $SO_SOFTHSM --list-mechanisms
pkcs11-tool --module $SO_KRYOPTIC --list-mechanisms
pkcs11-tool --module $SO_NETHSM --list-mechanisms
```
This shows all operations an HSM can do. Different HSMs differ!

-----------------

#### Hashing
```
echo -n "I'm starting to like this HSM stuff" > blah.txt
pkcs11-tool --module $SO_SOFTHSM --token Token1 --mechanism SHA256 --hash -i blah.txt | xxd -p -c 64
pkcs11-tool --module $SO_KRYOPTIC --token Token1 --mechanism SHA256 --hash -i blah.txt | xxd -p -c 64
sha256sum blah.txt
# Now do $SO_NETHSM (--token NitroNetHSM, or just omit --token) and compare the Error to the --list-mechanisms output above
```
Like sha256sum and openssl, your token could do hashing.  
The *xxd -p -c 64* is just to convert the binary output to human-readable, sha256sum-like, output.  
*Bug Alert: With pkcs11-tool -i and -o, please make sure you have only 1 space between it and the filename!*  

---------------

[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide16.md)
