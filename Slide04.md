-------------------------
## HSM Formfactors
An HSM can be:

* A networked hardware appliance like the Thales Luna
* A locally running piece of software on a server, like [SoftHSM](https://github.com/opendnssec/SoftHSMv2)
   or [kryoptic](https://github.com/latchset/kryoptic/)
* A PCI card or USB device (e.g. YubiHSM)
* A cloud service or cloud managed device
* A docker/podman container (NitroKey has one: [NetHSM](https://hub.docker.com/r/nitrokey/nethsm))

    > *Note NitroKey is not AWS Nitro, that is just a name clash*

Your bankcard could be viewed as an HSM... maybe.  
If you have a modern computer or laptop, you could have a TPM (Trusted Platform Module) inside it, these have a lot in common with an HSM.

--------------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide05.md)
