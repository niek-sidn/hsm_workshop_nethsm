# hsm_workshop_nethsm

## NetHSM Server
(incus launch images:ubuntu/noble --vm nethsmserver)  
Create an Equinix host with:  
  Ubuntu Noble  
  hostname centr-dublin01  
  tags: Niek, CENTR, NetHSM  
  1 public ip4, no public ip6, /31 private ip4  
*Here we use 192.168.13.13 as a standin for the actual public ip4*

after it is up:  
`ssh -l root -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" -o "LogLevel ERROR" 192.168.13.13  #(use actual pub ip4 of the nethsmserver)`  

`apt-get update && apt-get upgrade -y && apt-get install -y git ca-certificates curl \`  
`&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \`  
`&& chmod a+r /etc/apt/keyrings/docker.asc \`  
`&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \`  
`&& apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \`  
`&& systemctl enable --now docker`

`git clone https://github.com/niek-sidn/hsm_workshop_nethsm.git`

``` bash
cd hsm_workshop_nethsm
rm -rf files/nitrokey-nethsm/data
export NETHSM_PUB_IPV4="192.168.13.13" #(use actual pub ip4 of the nethsmserver)
```

*NOTE: edit files/hsm-client/hsm_env_vars.envsubst if you do not want to use passwords from a public GitHub repo!!!*  
`vim files/hsm-client/hsm_env_vars.envsubst`  
`# envsubst from the gettext package, probably already present`  
`envsubst '$NETHSM_PUB_IPV4' < files/hsm-client/hsm_env_vars.envsubst > files/hsm-client/hsm_env_vars`  
`envsubst '$NETHSM_PUB_IPV4' < compose.yml.envsubst > compose.yml`  

`docker compose up -d --build`  
`docker compose logs`

`docker compose exec -it hsm-client bash`  
`curl $CURLOPTS --user "admin:$ADMINPASS" -X GET $API/users -H 'accept: application/json' | jq .`  
`curl $CURLOPTS --user "admin:$ADMINPASS" -X GET $API/namespaces -H 'accept: application/json' | jq .`  

From other locations:  
`curl --silent --insecure --user "admin:adminpass32768" -X GET https://192.168.13.13:32768/api/v1/namespaces -H 'accept: application/json' | jq . #(use actual pub ip4 of the nethsmserver and the actual password)`  

## login server
(incus launch images:ubuntu/noble --vm shellserver)  
Create an Equinix host with:  
  Ubuntu Noble  
  hostname centr-dublin02  
  tags: Niek, CENTR, SHELLHOST
  1 public ip4, no public ip6, /31 private ip4  
*Here we use 123.123.123.123 as a standin for the actual public ip4*

after it is up:  
`ssh -l root -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" -o "LogLevel ERROR" 123.123.123.123  #(use actual pub ip4 of the login server)`

`apt-get update && apt-get upgrade -y && apt-get install -y git ca-certificates curl pwgen openssh-server \`  
`&& curl -fsSL https://pkgs.zabbly.com/key.asc -o /etc/apt/keyrings/zabbly.asc \`  
`&& chmod a+r /etc/apt/keyrings/zabbly.asc \`  
`&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/zabbly.asc] https://pkgs.zabbly.com/incus/stable $(. /etc/os-release && echo "$VERSION_CODENAME") main" | sudo tee /etc/apt/sources.list.d/zabbly.list > /dev/null \`  
`&& systemctl enable --now ssh \`  
`&& apt-get update && apt-get install -y incus`  

`git clone https://github.com/niek-sidn/hsm_workshop_nethsm.git`  

``` bash
incus admin init
# keep pressing enter or follow this:
Would you like to use clustering? (yes/no) [default=no]:
Do you want to configure a new storage pool? (yes/no) [default=yes]:
Name of the new storage pool [default=default]:
Name of the storage backend to use (dir, lvm, lvmcluster, btrfs) [default=btrfs]: dir
Where should this storage pool store its data? [default=/var/lib/incus/storage-pools/default]:
Would you like to create a new local network bridge? (yes/no) [default=yes]:
What should the new bridge be called? [default=incusbr0]:
What IPv4 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: 10.165.184.1/24
Would you like to NAT IPv4 traffic on your bridge? [default=yes]:
What IPv6 address should be used? (CIDR subnet notation, “auto” or “none”) [default=auto]: none
Would you like the server to be available over the network? (yes/no) [default=no]:
Would you like stale cached images to be updated automatically? (yes/no) [default=yes]:
Would you like a YAML "init" preseed to be printed? (yes/no) [default=no]: no
```

`vim /etc/shells`  
`...`  
`/usr/local/bin/incusshell`  
`...`

`vim /usr/local/bin/incusshell`  
`...`  
`#!/bin/bash`  
`sudo /usr/bin/incus shell $USER`  
`...`  
`chmod 755 /usr/local/bin/incusshell`

``` bash
update-alternatives --config editor  # pick your fave
visudo -f /etc/sudoers.d/users
%users ALL=(root) NOPASSWD:/usr/bin/incus shell user*
```

``` bash
# check all sshd_config(.d) for 'PasswordAuthentication no' instances
...
for example vim /etc/ssh/sshd_config and/or rm /etc/ssh/sshd_config.d/*
...
systemctl reload ssh
```

`export NETHSM_PUB_IPV4="192.168.13.13" #(use actual pub ip4 of the *nethsmserver* host)`  
`export PARTPASS_A="t0PZeCr3Tz"  # use the same pass as on nethsmserver`   
`export PARTPASS_O="ZeCr3Tz"  # use the same pass as on nethsmserver`  
`envsubst '$NETHSM_PUB_IPV4,$PARTPASS_A,$PARTPASS_O' < hsm_workshop_nethsm/files/p11nethsm.conf.envsubst > hsm_workshop_nethsm/files/p11nethsm.conf`  
`envsubst '$NETHSM_PUB_IPV4,$PARTPASS_A,$PARTPASS_O' < hsm_workshop_nethsm/files/part_env_vars.envsubst > hsm_workshop_nethsm/files/part_env_vars`  

``` bash
# we are going to make many users, and above 13 we would run out of subuids on the default settings.
# it is unclear to me why Ubuntu reserve 65353 subuids/gids per system user. Possibly for things like
# running podman as non-root user. Root's subuids/gids, used bij Incus, are in /etc/subuid & /etc/subgid
vim /etc/login.defs
SUB_UID_COUNT   1024
SUB_UID_MAX		1000000
SUB_GID_COUNT   1024
SUB_GID_MAX		1000000
```

`export USERPASS=$(pwgen 10 1)`  
`echo ${USERPASS}`  
`e.g. XXXXX-XXXXX`  
`for X in {1..30}; do`  
`export NS=ns${X}`  
`envsubst '$NS' < hsm_workshop_nethsm/files/p11nethsm.conf >  hsm_workshop_nethsm/files/p11nethsm.conf-${X}`  
`envsubst '$NS' < hsm_workshop_nethsm/files/part_env_vars >  hsm_workshop_nethsm/files/part_env_vars-${X}`  
`useradd -d /home/user${X} -m -G users -s /usr/local/bin/incusshell -p $(echo ${USERPASS} | openssl passwd -1 -stdin) user${X}`  
`incus launch images:ubuntu/noble user${X}`  
`sleep 2`  
`incus exec user${X} -- mkdir -p /usr/local/etc/nitrokey/`  
`incus exec user${X} -- mkdir -p /usr/local/lib/nethsm/`  
`incus exec user${X} -- apt install -y wget opensc curl jq softhsm2`  
`incus file push /root/hsm_workshop_nethsm/files/part_env_vars-${X} user${X}/root/hsm_env_vars`  
`incus file push /root/hsm_workshop_nethsm/files/hsm-client/bashrc user${X}/root/.bashrc`  
`incus file push /root/hsm_workshop_nethsm/files/p11nethsm.conf-${X} user${X}/usr/local/etc/nitrokey/p11nethsm.conf`  
`incus file push /root/hsm_workshop_nethsm/files/nethsm-pkcs11-vv1.6.0-x86_64-ubuntu.24.04.so user${X}/usr/local/lib/nethsm/nethsm-pkcs11-vv1.6.0-x86_64-ubuntu.24.04.so`  
`done`  
`echo ${USERPASS}`  


#### Enter user container as root
`ssh user1@123.123.123.123 #(use actual pub ip4 of the login server)`  
`password: XXXXX-XXXXX # see echo ${USERPASS} output above`  

#### cleanup login server
``` bash
for X in {1..30}; do
userdel -r user${X}
incus stop user${X}
rm hsm_workshop_nethsm/files/part_env_vars-${X}
rm hsm_workshop_nethsm/files/p11nethsm.conf-${X}
sleep 2
incus delete user${X}
done
```

