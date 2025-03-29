---------
## Enough of this pkcs11-tool, let's do something fun and useful!
#### Okay, how about a fast DNSSEC signing Knot nameserver that has no local keys?

Look at this sad, non-signing, nameserver I got you.  
Run:  
``` bash
knotc zone-status
dig @::1 +norec +multi +dnssec example.com soa
# Knot runs, but no DNSSEC :-(
```

Take a look at its config in `/etc/knot/knot.conf`  
Were we to uncomment dnssec-signing and dnssec-policy right now *(DON'T!)*, we'd get all our keys on the server and in RAM.  
(keys would be in `/var/lib/knot/keys/keys/*.pem`)  
That would be even more sad than no signing at all.  

Let's help it along!  
First recall how you collect the necessary information:  
``` bash
echo $SO_NETHSM  # copy to your paste buffer  
p11tool --provider $SO_NETHSM --list-token-urls
```
(no need to copy it)  

Edit the config `vim /etc/knot/knot.conf`  
edit the keystore section:  
* At **backend:** change *pem* to *pkcs11*
* At **backend:** uncomment and edit:  
  `config: "pkcs11:pin-value= /usr/local/lib/nethsm/nethsm-pkcs11-vv1.6.0-x86_64-ubuntu.24.04.so"`
* Way down at **zone**: uncomment *dnssec-signing* and *dnssec-policy* for example.com

Note: it is certainly possible to use SoftHSM here, but you are entering a world of chown/chmod/usermod-hurt.


