----------------------
## CloudHSM 2
**Cloudflare** made a nice assessment of cloudHSMs, and how to use them,
that is somewhat up-to-date.  
Background: They offer a "key server" product that can talk to HSM's via the
standard PKCS#11 "language" (PKCS11 will be addressed in this workshop):  
[source](https://developers.cloudflare.com/ssl/keyless-ssl/hardware-security-modules)
>*TLDR;* They mention several types of hardware that can be used + instructions.  
>          They mention several brands of cloud based HSM\'s + instructions  
>          AWS CloudHSM, IBM Cloud HSM, Azure Dedicated HSM, Azure Managed HSM, Google Cloud HSM

**NitroHSM** is a German company that has created an open source HSM.  
It is real hardware, but they also offer Docker/Podman version of it for testing and* production, and they have a demo-server.  
If compliancy to a standard (FIPS) or tamperproofing is not your *main* goal, it can offer an off-server
solution.  
The container images can be used to "roll your own" HSM-oid.  
[NetHSM container image](https://hub.docker.com/r/nitrokey/nethsm) &
[NetHSM hardware](https://www.nitrokey.com/products/nethsm)  
It is to slow for .nl, but .amsterdam (approx. 50,000 RR's unsigned) works, signed in 2 minutes.  

### Rejoice:
This workshop uses the NetHSM (testing) container image on a MAAS host at Equinix.  
So you will get some hands on experience with it, and it's setup is in the PREP "slide" in this repo.

-------------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide14.md)
