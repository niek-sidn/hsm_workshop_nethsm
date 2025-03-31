--------------------------
## CloudHSM 1
Recently we see a lot cloud of activity on the HSM front.  
It is (a.o.) aimed at running a TLS service without having the keys for
this in memory on a (web)server-instance.  
A.k.a.: "Keyless SSL" (but of course there is a key, just not on the server that uses it)

Like non-cloud HSMs, cloud HSMs probably offer the PKCS11 "language" as a standardised communication path
(pkcs11: more below).  
Sometimes it is just a keyring in disguise (could be good or bad).  
Sometimes only usable from cloud VM instances on the same platform  
(e.g. AWS: access only through ENI interface, only from within your VPC).  
Sometimes it is a full blown Thales/Safenet/Luna (partition) with or
without a wrapper (e.g. IBM cloud hsm).  
If you are a Thales customer: they also offer a cloud product, that even integrates with their hardware.  
[Link to trial](https://thales.eu.market.dpondemand.io/signup/)  
AWS offers CloudHSM at $1.50 an hour, so that looks sort of reasonable.

### Beware
But, as with all cloud products...  
* ...beware of vendor lock-in, and keep an eye on your wallet, cloud can get expensive real fast.  
* Also: maybe a vendor also has a charge per hour / charge per key / charge per use.  
* ...Or all of the above..., please ask your teams financial engineer.

E.g. AWS CloudHSM are always in a cluster (empty permitted, >1 = redundancy,  
nice: keys are replicated on all cluster members)  
* ... but: you do pay per HSM, not per cluster!  
* ... otoh: if you encrypt, then backup your CloudHSM, you can then throw away the HSM to get an empty cluster.  
No need to keep it running, you can always restore and decrypt on a new instance.  
* Deployment can take quite some time, so a "throw-away" HSM maybe is not such an attractive scenario.
* The tamperproofness/Compliancy of all cloud hsm's is based on trusting the cloud hsm's provider and it's certifications  
(Alibaba CloudHSM looks like a 1-on-1 copy of AWS. Knowing that it could be technically equivalent, but are you considering them as a supplier?)

----------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide13.md)
