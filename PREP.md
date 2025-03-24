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

`cd hsm_workshop_nethsm`  
`rm -rf files/nitrokey-nethsm/data`  
`export NETHSM_PUB_IPV4="192.168.13.13" #(use actual pub ip4 of the nethsmserver)`  

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
`&& systemctl enable --now ssh`  
`&& apt-get update && apt-get install -y incus`  

`git clone https://github.com/niek-sidn/hsm_workshop_nethsm.git`  

`incus admin init`  
> *keep pressing enter*

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

`visudo -f /etc/sudoers.d/users`  
`%users ALL=(root) NOPASSWD:/usr/bin/incus shell user*`

`export NETHSM_PUB_IPV4="192.168.13.13" #(use actual pub ip4 of the *nethsmserver* host)`  
`export PARTPASS_A="t0PZeCr3Tz"  # use the same pass as on nethsmserver`   
`export PARTPASS_O="ZeCr3Tz"  # use the same pass as on nethsmserver`  
`envsubst '$NETHSM_PUB_IPV4,$PARTPASS_A,$PARTPASS_O' < hsm_workshop_nethsm/files/p11nethsm.conf.envsubst > hsm_workshop_nethsm/files/p11nethsm.conf`  
`envsubst '$NETHSM_PUB_IPV4,$PARTPASS_A,$PARTPASS_O' < hsm_workshop_nethsm/files/part_env_vars.envsubst > hsm_workshop_nethsm/files/part_env_vars`  

`export USERPASS=$(pwgen 10 1)`  
`echo ${USERPASS}`  
`e.g. XXXXX-XXXXX`   
`for X in {1..3}; do`  
`export NS=ns${X}`  
`envsubst '$NS' < hsm_workshop_nethsm/files/p11nethsm.conf >  hsm_workshop_nethsm/files/p11nethsm.conf-${X}`  
`envsubst '$NS' < hsm_workshop_nethsm/files/part_env_vars >  hsm_workshop_nethsm/files/part_env_vars-${X}`  
`useradd -d /home/user${X} -m -G users -s /usr/local/bin/incusshell -p $(echo ${USERPASS} | openssl passwd -1 -stdin) user${X}`  
`incus launch images:ubuntu/noble user${X}`  
`sleep 2`  
`incus exec user${X} -- mkdir -p /usr/local/etc/nitrokey/`  
`incus exec user${X} -- mkdir -p /usr/local/lib/nethsm/`  
`incus exec user${X} -- apt install -y wget opensc curl jq`  
`incus file push /root/hsm_workshop_nethsm/files/part_env_vars-${X} user${X}/root/hsm_env_vars`  
`incus file push /root/hsm_workshop_nethsm/files/bashrc user${X}/root/.bashrc`  
`incus file push /root/hsm_workshop_nethsm/files/p11nethsm.conf-${X} user${X}/usr/local/etc/nitrokey/p11nethsm.conf`  
`incus file push /root/hsm_workshop_nethsm/files/nethsm-pkcs11-vv1.6.0-x86_64-ubuntu.24.04.so user${X}/usr/local/lib/nethsm/nethsm-pkcs11-vv1.6.0-x86_64-ubuntu.24.04.so`  
`done`  


#### Enter user container as root
`ssh user1@123.123.123.123 #(use actual pub ip4 of the login server)`  
`password: XXXXX-XXXXX # see echo ${USERPASS} output above`  

#### cleanup login server
`for X in {1..3}; do`  
`userdel -r user${X}`  
`incus stop user${X}`  
`sleep 2`  
`incus delete user${X}`  
`done`


