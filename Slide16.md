---------------------------------
## PKCS#11 (part 2)
Recap: As mentioned before PKCS#11 works with "Slots" and "Tokens".
[Illustrated here](https://github.com/tpm2-software/tpm2-pkcs11/blob/master/docs/illustrations/reader-slot-token-obj.png)  
In PKSC11 a **"Token"** is the term used for a device that can do **crypto operations**, e.g. a smartcard 
or the crypto module of an HSM or an HSM partition (virtual HSM on e.g. Thales Luna).  
This name is not surprising: USB devices for OTP and other things that go into a slot are often also called "tokens".

In the smartcard world, and also in the USB-HSM world, there are of
course **actual slots** to put a token in: the card reader or a USB slot.  
But on an HSM appliance this is **less obvious**, so slots and tokens are
virtual. (and way less limited in number)

Like in the real world, slots can also be **empty**, we saw this in the exercises.  
On a Luna, there is a (PCI?) card in the appliance with the crypto
module on it. This is the home of virtual non empty slots if I'm correct.  
On a Luna, a partition is a virtual slot+token, and 2 partitions on 2
appliances, combined in an ha-group, present as a single HSM.

Often HSM and slot+token are **seen as equivalent**, this is why the
OpenDNSSEC conf.xml has only a <TokenLabel\> configuration option.  
ODS doesn't need to know the actual HSM, if it talks to the .so/driver
it will find it.  
(configured in Chrystoki.conf, softhsm.conf, p11nethsm.conf)   
It's a bit hazy what exactly a Slot is on a Luna, the 'slot list' command
actually lists all partitions as "Net Token Slot" and the virtual HSM
in an ha-group (called: HA Virtual Card Slot).

**Inside a Token are objects**, e.g. keys, key-pairs, certificates.  
Keys come in different types: public, private en secret keys. The latter
for symmetrical encryption.  
An object can be classified as public or private, but this has nothing
to do with public/private keys, in the PKI sense of the word.  
It just specifies what objects can be used/read unauthenticated.

Because PKCS#11 is a standard, there are projects like the already mentioned:
[p11-glue](https://p11-glue.github.io/p11-glue/)  
P11-glue: should make 2 or more different HSMs or Key-rings that
support PKCS11 available through 1 "in between" driver (.so/module).  

-------------------
## Exercise "pkcs11-tool: gimme the keys & lemme in"
#### Your first key!
```
pkcs11-tool --module $SO_SOFTHSM --token Token1 --keypairgen --id 1 --label ec256nr1 --key-type EC:secp256r1
```    
Error, not logged in. Same for SO_KRYPOTIC  

... but SO_NETHSM has credentials and token in its p11nethsm.conf, so it works without supplying a pin or token on the command line:  
`pkcs11-tool --module $SO_NETHSM --keypairgen --key-type EC:secp256r1 --label "ec256nr1"`  

------------------------
#### Try again, but better:
```
pkcs11-tool --module $SO_SOFTHSM --token Token1 --keypairgen --id 1 --label ec256nr1 --key-type EC:secp256r1 --login --login-type user --pin 0000
```
Yes! We got one!

---------
#### Let see it:
```
pkcs11-tool --module $SO_SOFTHSM --token Token1 --list-objects
```
Did you notice we have only the pub part? Again, not logged in!

--------------
#### Try again but better:
```
pkcs11-tool --module $SO_SOFTHSM --token Token1 --list-objects --login --login-type user --pin 0000
```
That's better, we now see the private and public part (same labels!)  
We do not see the actual keys using this command, not surprising for the private part, since the HSM obviously never wants to show its private parts.  
But also the public part is not shown, this is just not the right command for that.

-------
#### Bonus: "--pin" implies "--login --login-type user"  (same with "--so-pin")
```
pkcs11-tool --module $SO_SOFTHSM --token Token1 --list-objects --pin 0000
```

------------
#### Let's make a second key pair, with a different curve
```
pkcs11-tool --module $SO_SOFTHSM --token Token1 --keypairgen --id 2 --label ec256nr2 --key-type EC:prime256v1 --pin 0000
# for NetHSM leave out token and id (id gets generated)
pkcs11-tool --module $SO_NETHSM --keypairgen --label ec256nr2 --key-type EC:prime256v1
```
 (For RSA: "--key-type RSA:2048")  
 (How to find the ECDSA key types: openssl ecparam -list_curves)

In the past I have noticed unpredictable results with SoftHSM when using "--label" instead of "--id", better use both.  

-----------
#### And let's actually see the public part:
```
pkcs11-tool --module $SO_SOFTHSM --token Token1 --read-object --type pubkey --label ec256nr2 --id 2 -o ec256nr2-pub.der
```
No login needed, public parts are not marked as non-extractable or sensitive.  

We output the pub part to a DER (binary) file, you can cat it to base64 ...

--------
#### ... or use OpenSSL to make a PEM:
```
openssl ec -pubin -inform DER -in ec256nr2-pub.der -outform PEM
```
Notice you get the "-----BEGIN PUBLIC KEY-----" for free.

-----------

#### pkcs11 URI
What if your software needs pkcs11 information in URI format? E.g. Knot.
```
sudo apt install gnutls-bin
p11tool --provider $SO_SOFTHSM --list-tokens
p11tool --provider $SO_SOFTHSM --list-all "pkcs11:token=Token1" # or use more complete url
```
That should at least be a nice starting point. It probably needs pin=000; in it too.

--------------------
## Exercise "pkcs11-tool: start signing already!"
Okay, let's go then.
#### First make something that resembles a DNS RR:
```
echo -n 'nl.                  3600    IN      SOA     ns1.dns.nl.    hostmaster.domain-registry.nl. 2023110219 3600 600 2419200 600' > soa.txt
```

----------------
#### In the real world, signatures are made on hashes, so:
```
pkcs11-tool --module $SO_SOFTHSM --token Token1 --mechanism SHA256 --hash -i soa.txt -o soa.hash
```
(remember: NetHSM cannot hash, use: openssl dgst -sha256 -binary soa.txt > soa.hash )

-------------------
#### Signing needs keys, so we use the keys we made earlier:
```
pkcs11-tool --module $SO_SOFTHSM --token Token1 --sign --label ec256nr2 --id 2 --mechanism ECDSA -i soa.hash -o soa.sig
```
Needs PIN, you should know why.

-----------
#### Let's see:
```
cat soa.sig | base64
```
That looks remarkably like an EC RRSIG!

---------------
#### Let's verify:
```
pkcs11-tool --module $SO_SOFTHSM --token Token1 --label ec256nr2 --id 2 --verify -m ECDSA -i soa.hash --signature-file soa.sig
```
That should work, no PIN needed  
(remember: NetHSM cannot verify)


------------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide17.md)
