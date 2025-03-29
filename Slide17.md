## Other PKCS#11 interfaces
Java Cryptography Extensions, MS CryptoNG.  
And several libraries that use PKSC11 in the background, so you don't have to deal with it very much.  
<https://python-pkcs11.readthedocs.io/en/latest/>  
<https://pkcs11wrap.sourceforge.io/api/samples.html#encrypt-and-decrypt>   
<https://aws.amazon.com/blogs/apn/signing-data-using-keys-stored-in-aws-cloudhsm-with-python/>  
<https://github.com/miekg/pkcs11>  
Note: YMMV, not all fully matured.

--------------------
## Exercise "Symmetry"
I promised I'd show you how to use an HSM for symmetric encryption and decryption.  
Time to deliver.  

-------------------
``` bash
pkcs11-tool --module $SO_NETHSM --keygen --key-type AES:128 --label aes128nr1
echo -n 'This is top secret!!!___________' > mysecret.txt  # padding to get a multiple of 16 bytes
pkcs11-tool --module $SO_NETHSM --encrypt --label aes128nr1 -m AES-CBC --iv "deadbeefdeadbeefdeadbeefdeadbeef" -i mysecret.txt -o mysecret.aes
rm mysecret.txt
base64 mysecret.aes
pkcs11-tool --module $SO_NETHSM --decrypt --label aes128nr1 -m AES-CBC --iv "deadbeefdeadbeefdeadbeefdeadbeef" -i mysecret.aes
pkcs11-tool --module $SO_NETHSM --delete-object --label aes128nr1 --type secrkey
# Your secret is now forever safe.
```
Note: With pkcs11-tool version 0.22 I never managed to use symmetrical encryption (e.g. AES), it is not supported, even though the
HSM/Token does report it and I can create an AES key with pkcs11-tool just fine.
Error: pkcs11-tool: unrecognized option '--encrypt'.

--------------------
[Next](https://github.com/niek-sidn/hsm_workshop/blob/main/Slide18.md)
