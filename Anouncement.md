-----------------
## About this Workshop
If you are working in IT you have probably at least *heard* about Hardware Security Modules (HSMs).  
But what can you do with them, and for what type of problem could an HSM be a solution?  

I have worked with HSMs at SIDN quite a lot, specifically in the DNSSEC signing context.  
SIDN, Stichting Internet Domeinregistratie Nederland, is the Foundation for Internet Domain Registration in the Netherlands.  
Basically we publish the .NL ccTLD for the good of the Internet, and facilitate changes to it for our registrars.  
The .NL top level domain contains about 6 million delegations and over 10 million DNSSEC signatures.  
Our Thales Luna 7 HSM cluster setup makes these signatures in about 5 minutes at over 35000 signatures per second.

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

After this workshop you should have gained some confidence when working with an HSM, or when researching HSM stuff on your own.

In 2024 I gave such a workshop twice in-house at SIDN.  
People enjoyed it and actually learned from it. [Link to the 2024 workshop](https://github.com/niek-sidn/hsm_workshop)  
But I also received some feedback that I wanted to process before giving the workshop again.  
Also the people from NitroKey had published their docker image for testing their NetHSM that I wanted to use in my workshop to add more realism.  
Meanwhile I was requested to give the workshop at CENTR tech 52 in Dublin.

*Some "expectation management": HSM work often involves running proprietary software and commands from the manufacturer.  
However, in this workshop we cannot focus on specific brands and their commands, we will have to keep things more general.*


-----------------
## Setup of the workshop
Part theory with slides.  
Part hands-on in a Linux terminal (see below).  
No prior knowledge of HSMs is needed.  
No advanced math or crypto knowledge is needed, but you should know what public and private key encryption/signing is.  
No advanced DNS or DNSSEC knowledge is needed, but the workshop uses DNS based examples.  
Basic experience issuing shell commands is required.

Make a choice:

* Highly recommended: Use an ssh-client (Linux / Putty / MacOS terminal) to ssh into a login server that SIDN will provide.
* Or: make sure you have a laptop that can run a terminal, you can install software on, and that has access to the internet.  
(You probably can also get away with using Virtualbox, LXC/Incus, or an other virtual environment running Ubuntu, just make sure you can install software and connect to the internet.)  

If you will be using a shell on your laptop directly or in a VM or container, make sure you have this software installed:

* opensc  # make sure it is version 0.23 or higher, Ubuntu 24.04 and Debian 12 are good.
* dig (or equivalent)  # apt: dnsutils
* wget
* xxd
* openssl
* *optional*: libtpm2-pkcs11-tools, libtpm2-pkcs11-1

If you will be using an ssh-client you do not need to install any other software on your laptop.


-------------------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide01.md)
