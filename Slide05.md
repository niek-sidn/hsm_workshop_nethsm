-----------------------
## Capacities
Different HSM's *do* or *do not* have:

-   Networking (SoftHSM doesn't, USB/PCI HSMs vary).
-   High availability networking, loadbalancing, active-active option.
-   Tamperproofing, hardened appliance-OS.
-   A different surface area of attack compared to a 'normal' server.
-   Safe destruction of key material and/or configuration, self-destruct
    button.
-   (FIPS) Certifications.
-   Virtualisation (Thales Luna: partitions, NetHSM: namespaces).
-   A secured backup mechanism
-   Role based access, M of N based authentication, PEDs, or Password based.
-   A form of customer support.
-   A sales department that is focussed on your specific use case (What's DNSSEC?)
-   Exportable keys
-   Physical anti-theft (chained to the rack or a dangling USB key?).
-   An api/library, gui, cli, cloud-integration, etc.
-   A price tag that gives you nightmares.
-   Different algorithm support (at different speeds) RSA, EC.
-   Redundancy (e.g. PSU, network bonding).
-   A backup battery to allow moving the device.
-   Automatic locking of keys.
-   Auditability of access / audit trail.
-   "Open source"ness (Nitro NetHSM looks promising).
-   SNMP.
-   And this is a very incomplete list...

In most cases, an HSM is contacted through an .so module (let's call it a "driver")

---------------------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide05b.md)

