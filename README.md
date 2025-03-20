-----------------
## About this Workshop
If you are working in IT you have probably at least *heard* about Hardware Security Modules (HSMs).  
But what you can do with it, and for what type of problem could an HSM be a solution?  

I have worked with HSMs at SIDN quite a lot, specifically in the DNSSEC signing context.  
SIDN, Stichting Internet Domeinregistratie Nederland, is the Foundation for Internet Domain Registration in the Netherlands.  
Basically we publish the .NL ccTLD for the good of the Internet, and facilitate changes to it for our registrars.  
The .NL top level domain contains about 6 million delegations and over 10 million DNSSEC signatures.  
Our Thales Luna 7 HSM cluster setup makes these signatures in about 5 minutes at 35000 signatures per second.

Mid 2023 people at SIDN started showing interest in some sort of HSM "Course".  
Since then even more people got interested every time we mentioned it.  
Specifically it would have to be some hands-on thing, because IT-people cannot live on theory alone.  
So "Course" became "Workshop".  

People asked for a focus on general HSM knowledge, not on specific devices.  

So the aim of the workshop became:  
- Learning what an HSM is used for, and get some experience using a networked HSM.  
- Learning how to use an HSM in an application.

Who is this workshop for?  
- people that do not really know what an HSM is, and want to know what it is all about.  
- people that know the basics of what an HSM is, but did not yet work or play with them.

After this workshop you should have gained some confidence when working with an HSM or when researching HSM stuff on your own.

In 2024 I gave such a workshop twice in-house at SIDN.  
People enjoyed it and actually learned from it. [Link to the 2024 workshop](https://github.com/niek-sidn/hsm_workshop)  
But I also received some feedback that I wanted to process before giving the workshop again.  
Meanwhile I was requested to give the workshop at CENTR tech 52 in Dublin.

Some "expectation management": HSM work often involves running proprietary software and commands from the manufacturer.  
However, in this workshop we cannot focus on specific brands and their commands, we will have to keep things more general.


-----------------
## Setup of the workshop
Part theory with slides.  
Part hands-on in a Linux terminal.  
No prior knowledge of HSMs is needed.  
No advanced math or crypto knowledge is needed, but you should know what public and private key encryption/signing is.  
No deep DNS or DNSSEC knowledge is needed, but the workshop uses DNS based examples.  
Basic experience issueing shell commands is needed.

Make sure you have a laptop that can run a terminal or ssh-client, and that has access to the internet.  
You can either run a shell directly or use an ssh-client (Linux / Putty / MacOS terminal) to connect to a 
server that SIDN will provide.

You can probably get away with using Virtualbox, LXC/Incus, or an other virtual environment running Ubuntu.

If you will be using an ssh-client you do not need to install any other software.

If you run a shell directly or in a VM or container, make sure you have this software installed:

- opensc (Apt package name) # make sure it is version 0.23 or higher, Ubuntu 24.04 and Debian 12 are good.

- dig or equivalent # Apt: dnsutils

- xxd

- openssl

- optional: libtpm2-pkcs11-tools, libtpm2-pkcs11-1


Theory mixed with commandline work to make it less boring and get
experienced (sorry, Jimi Hendrix was playing while writing this)

For the hands-on work you can use any host you can install software
packages on and that has a shell.
I'm using Ubuntu 22.04 Linux and bash on a LXD container on my laptop. You
choose your own, but as always ymmv.

If you got confused already, please ask one of the experienced people to
help you. I can provide a linux shell if you want, please ask me. You'll still
need Putty or equivalent ssh-client to use it.

So you Need:

-   a Linux* commandline to issue hsm and pkcs11 commands.
-   an HSM you can use or install SoftHSM on your host.
-   I repeat: I can provide you with this, if you ask me beforehand.

*)You can try doing this workshop on Mac or Windows if you want, but
I'm not really able to help you beyond this:\
Windows Installer for SoftHSM:[SoftHSM2-for-windows](https://github.com/disig/SoftHSM2-for-windows)\
Windows Installer for OpenSC: [OpenSC](https://github.com/OpenSC/OpenSC)\
Mac: ???

-------------------
## Prior knowledge
There is no time to explain things beyond HSM\'s, so you should:

-   know what the essence of assymmetric (public key) and symmetric
    encryption is.
-   know that you can also do digital signing with a public-private
    key-pair.
    (that is basically what DNSsec signing is all about).
-   use youtube if you lack this knowledge.

-------------------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide01.md)
