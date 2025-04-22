------------------
# CENTR tech 52  HSM Workshop

## Intro
If you are working in IT you have probably at least *heard* about Hardware Security Modules (HSMs).  
But what can, or can't, they do for you, and for what type of problem could an HSM be a solution?  
Even more importantly: How do I get to know one to play around with?

## whoami
Niek Willems
(pronounced "Neek" in Dutch, but "Nick" will do)  
He/him/his.

Member of Team DNS at **SIDN, the .NL registry**.  
*Stichting Internet Domeinregistratie Nederland (Foundation for Internet Domain Registration in the Netherlands)*.  
Basically we publish the .NL ccTLD for the good of the Internet, and facilitate changes to it for our registrars.  
Currently the .NL zone contains 6 million delegations, 10 million DNSSEC signatures.  
I mostly focus on our DNSSEC signer setup and DNS operations,  
but I'm also sometimes allowed to work on our CI/CD based "Infra As Code" DNS anycast platform ;-)  
We do OpenDNSSEC 2.1 and Thales Luna 7 HSM based signing. And BIND, Knot, NSD, GitLab & BMAAS based publication.


## Aim of the workshop

You will learn what an HSM is used for, and get some experience using a networked HSM.  
You will learn how to use an HSM in an application.  
After this workshop you should have gained some confidence in working with an HSM or in researching HSM stuff on your own.

## Get all of it
``` bash
git clone https://github.com/niek-sidn/hsm_workshop_nethsm.git
```
Should you want to do (or present) this workshop yourself, take a look at the [PREP](PREP.md) "slide" for instructions and inspiration.  

--------------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide01.md)
