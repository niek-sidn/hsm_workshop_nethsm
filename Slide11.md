-------------
## Your very own HSM! (sort of)
**SoftHSM2** is a software HSM emulator and reference implementation by NLnet Labs.  
Thanks to them you can use it for **free**. [link](https://github.com/opendnssec/SoftHSMv2)

*But* it has **no networking** and it needs to be installed on the server that needs to use the HSM,  
unless you are able to bolt on some networking. E.g. by using p11-kit in server mode.

[p11-glue 0.25 (includes p11-kit): using PKCS#11 to unite crypto libraries](https://p11-glue.github.io/p11-glue/p11-kit.html)

[Virtual PKCS #11 Module SoftHSMv2 by Primos TI](https://github.com/PrimosTI/softhsm2) (take a look in the 'samples' directory)

[Vegardit/docker-softhsm2-pkcs11-proxy](https://github.com/vegardit/docker-softhsm2-pkcs11-proxy/blob/main/README.md)

[PowerDNS PKCS#11 with p11-kit](https://doc.powerdns.com/authoritative/dnssec/pkcs11.html)

[A Stack Overflow thread on the subject](https://stackoverflow.com/questions/56756141/expose-softhsm-library-to-the-code-running-in-host-machine)

[A ServerFault thread on the subject](https://serverfault.com/questions/1166723/pkcs11-forwarding-clarifying-client-and-server-confusion)

[An OpenSC GitHub issue on the subject](https://github.com/OpenSC/libp11/issues/437)

*Please note:* SoftHSM2 is an excellent tool for testing, saving you a lot of money. But, as you can see from its contradictory name, it is no true HARDWARE security module and your secret keys are **in RAM** on your server that also hosts the software using it (and this software is possibly exposed to the internet).  

*Nice*: SoftHSM2 is a **drop in** for a real HSM, this means you have to change very little when switching to a real HSM.

A new but similar project is "kryoptic", a [pkcs11 soft token written in rust](https://github.com/latchset/kryoptic), also see [this blog by rcritten](https://rcritten.wordpress.com/2024/10/01/trying-a-new-pkcs11-driver-kryoptic/).  
I used to be able to build it, but alas.

--------------------
## Exercise "Introducing SoftHSM2 by NLnet Labs"
```bash
** sudo -i OR su - **
apt update
apt install -y softhsm2 man sudo
usermod -aG softhsm <your username>   ### !!! so non-root user can read /etc/softhsm/softhsm2.conf
```
------------
SoftHSM has virtual **"slots"**, in which **"tokens"** can be placed (like a card reader or USB port)\
***Token is just the term used for a device or virtual device that can do crypto operations, (like a smartcard or an USB-HSM).***\
A token can contain lots of key objects.\
[illustration](https://github.com/tpm2-software/tpm2-pkcs11/blob/master/docs/illustrations/reader-slot-token-obj.png)
```bash
sudo softhsm2-util --show-slots
softhsm2-util --show-slots
```
Slots are numbered, but there always an empty slot available/created for a new token slot.\
SoftHSM keeps its users separated, user_x cannot list user_y's slots. But root sees all.

**Note:** Here you meet for the first time a **vendor tool** for using an HSM.\
SoftHSM -> softhsm2-util\
Thales -> lunacm, vtl, etc.\
NitroKey -> nitropy\
Also: OpenDNSSEC -> ods-hsmutil (not an HSM vendor, also: the HSM is not addressed directly)\
Also: Knot -> keymgr (not an HSM vendor, also: the HSM is not addressed directly)

---------------------------------

RTFM:
```bash
man softhsm2-util
```
Here you read what it is, and what it does: list, init, delete, import, user management.
But you'll see **no 'encrypt' or 'sign' commands** and you cannot just give SoftHSM a file and expect it to be signed or encrypted.
You need middleware, more on that later!

-------------
Your first token
```bash
softhsm2-util --init-token --free --label "Token1" --pin 0000 --so-pin 1234  # owned by current user!
softhsm2-util --show-slots     # use sudo if you want to see all slots
```
Notice that a token has been "inserted" (with an unexpected number), and a new free slot was created (also with an unexpected number).\
(--free just means: use first empty slot, so you do not have to look first)

The pin is a PIN (password) for using the token, but why twice? Because there are **2 users/roles** in SoftHSM.\
In SoftHSM the normal user can do crypto operations using the key objects in the token, and create or destroy tokens.\
In SoftHSM the Security officer ("SO") can reinitialise a token, not much else can be known from the documentation.

-------------
**NOTE** no keys are in this token yet! The token is just the cryptomodule, and softhsm2-util is not the tool for creating keys.
```bash
cat /etc/softhsm/softhsm2.conf
ls -lR /var/lib/softhsm/tokens/
```
Note: if you compiled SoftHSM yourself, according to my recipe, you should have an Sqlite3 db in /var/lib/softhsm/tokens/.\
      try: sqlite3 /var/lib/softhsm/tokens/....../sqlite3.db and command .dump to see all (hint: .quit/.help).

Please note: As I mentioned earlier, SoftHSM isolates its slots/tokens, a token created by a user is unavailable to other users.
This means that if you are creating tokens for a different user (e.g. Bind, Knot, OpenDNSsec) you need to use sudo. You'll learn this later.

-------------------
[Next](https://github.com/niek-sidn/hsm_workshop/blob/main/Slide12.md)
