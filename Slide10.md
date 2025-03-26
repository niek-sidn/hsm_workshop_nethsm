---------------
## HSM? NOT!
Arguments against using an HSM:

-   More **Complexity** in your setup = higher risk of human error
    -   Complex roles and operations (*?!?How many times you say I need to enter the PIN for the blue token!?!*)
    -   Complex backup procedures, think of it: the whole purpose is to keep keys in the HSM.
    -   More complex networking (if you do it right, e.g. specific VLAN)
-   Could make **automation** more difficult.
-   Sometimes **expensive** hardware (no, really expensive, like 'new car' expensive)
-   Risk of **vendor lock in** (luckily PKCS#11 is widely adopted)  
    Move to a different vendor could mean a KSK roll, the keys are locked inside!
-   Sometimes **overkill** (e.g. no FIPS required or tamper proofing is not needed)
-   **SoftHSM** used to *not* be recommended for production use by NLnetLabs (people do this anyway).  
    Recently I was unable to locate this statement.
-   **Long lived secrets**, think: encrypted document archive. Probably dependent on your ability to keep the keys available for longer than the life of the HSM.  
    (solutions: more than 1 HSM in HA setup / backups that are readable by the next HSM / key creation outside the HSM + import & store in safe)

----------------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide11.md)
