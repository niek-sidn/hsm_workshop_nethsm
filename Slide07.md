---------------------
## Use of random: Salt
Doing *hash operations* is an important function of an HSM.  
A hash is a one-way mathematical "door": going through is easy, but going back out is very difficult.  
A small change in input gets you a wildly different, and unpredictable, output  
Digitally signing is basically creating a hash of a text and the signing that hash.  
E.g. DNSSEC Algo 13 is ECDSA Curve P-256 signing of a SHA-256 hash of a DNS record.

But hashes can be precalcutated (and stored and indexed) into so-called rainbowtables.  
These tables can then e.g. be used in an "offline, stored dictionary attack".  
This is where some salt comes in. Modern hashing operations take some random before hashing.  
You can view this as a kind of password/key extender: a longer password
makes pre-calculation way more time consuming even if the extension is not secret.  

The DNSSEC NSEC3 mechanism uses hashing against zone-walking when creating proof of non-existence of a record name.  
NSEC3 can be salted. But the latest RFC advices against it:
> "In the case of DNS, the situation is different because the hashed
> names placed in NSEC3 records are always implicitly 'salted' by
> hashing the FQDN from each zone."  
[source](https://datatracker.ietf.org/doc/html/rfc9276#name-salt)

## Exercise "Finland is salty" (could it be the Salmiakki?)
Install dig (or kdig) on your computer or VM or container:
``` bash
apt install dnsutils  # OR knot-dnsutil
```
Issue this command (or your OS's equivalent):
``` bash
dig nsec3param fi. @1.1.1.1
```
--------------------
Now do .nl

--------------------
Now do .se

--------------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide08.md)
