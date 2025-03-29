---------------
## Use of random: IV
A lot of HSMs also offer *symmetric encryption and decryption*.  
E.g. AES. AES does not use salt, but it does need some random: the initialisation vector.  
An IV has a different purpose: with a different IV, even identical input and an identical key will
give you different output every time.  
Otherwise the enemy will probably recognize your "Attack at dawn!" message from last time you thought starting a war was a solution to your problems.

Later on you will learn to use an HSM for symmetric encryption and decryption,  
but at this stage let's not bite of more than we can chew:

---------------------
## Exercise "Cyberchef, your tool for all things crypto"
- Visit with *this* link: [CyberChef](https://cyberchef.io/#recipe=AES_Decrypt(%7B'option':'UTF8','string':'my_key1234567890'%7D,%7B'option':'UTF8','string':'0000000000000000'%7D,'CBC','Hex','Raw',%7B'option':'Hex','string':''%7D,%7B'option':'Hex','string':''%7D)&input=NDBiNmJhMWM1ZDI0ZDkzZjEwYmFhZTkzYzRmN2E5NzNhOGQ5YzQ4MDBiYmUyZmM0MzRlMTZiMTVjNzNjYTUxZg)

Now change the IV, but not the key and input. E.g. change the first zero to a 1.  
This is an area where IV and salt differ!  
As proof change my 1234 salt to 1235 [here](https://cyberchef.io/#recipe=SHA2('256',64,32)&input=MTIzNCNIU01zIGFyZSBzbyBjb29s)

By the way, an example of AES *encryption* is [this](https://cyberchef.io/#recipe=AES_Encrypt(%7B'option':'UTF8','string':'my_key1234567890'%7D,%7B'option':'UTF8','string':'0000000000000000'%7D,'CBC','Raw','Hex',%7B'option':'Hex','string':''%7D)&input=QXR0YWNrIGF0IGRhd24hISE)  
(To confuse the enemy, change the IV for every instance of this message you send, and don't forget to include the IV !)

Have a look at the left, see what CyberChef can do for you.

Now try something new like Base64 and unBase64. (Hint: drag & drop)

---------------
[Next](https://github.com/niek-sidn/hsm_workshop_nethsm/blob/main/Slide09.md)
