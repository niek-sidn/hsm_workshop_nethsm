# hsm_workshop_nethsm

## HSM
Create an Equinix host with:  
  Ubuntu Noble  
  hostname centr-dublin01  
  tags: Niek, CENTR, NetHSM  
  1 public ip4, no public ip6, /31 private ip4  
*Here we use 192.168.13.13 as a standin for the actual public ip4*

after it is up:  
`ssh -l root -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" -o "LogLevel ERROR" 192.168.13.13  #(use pub ip4)`

`apt-get update && apt-get upgrade -y && apt-get install -y git ca-certificates curl \`  
`&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \`  
`&& chmod a+r /etc/apt/keyrings/docker.asc \`  
`&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \`  
`&& apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \`  
`&& systemctl enable --now docker`

`git clone https://github.com/niek-sidn/hsm_workshop_nethsm.git`

`cd hsm_workshop_nethsm`  
`rm -rf files/nitrokey-nethsm/data`  
`export NETHSM_PUB_IPV4="192.168.13.13" #(use pub ip4)`  
`# envsubst from the gettext package, probably already present`  
`envsubst '$NETHSM_PUB_IPV4' < files/hsm-client/hsm_env_vars.envsubst > files/hsm-client/hsm_env_vars`  
`envsubst '$NETHSM_PUB_IPV4' < compose.yml.envsubst > compose.yml`  

*NOTE: edit files/hsm-client/hsm_env_vars if you do not want to use passwords from a public GitHub repo!!!*  

`docker compose up -d --build`  
`docker compose logs`

`docker compose exec -it hsm-client bash`  
`curl $CURLOPTS --user "admin:$ADMINPASS" -X GET $API/users -H 'accept: application/json' | jq .`  
`curl $CURLOPTS --user "admin:$ADMINPASS" -X GET $API/namespaces -H 'accept: application/json' | jq .`  

From other locations:  
`curl --silent --insecure --user "admin:adminpass32768" -X GET https://192.168.13.13:32768/api/v1/namespaces -H 'accept: application/json' | jq .`

## login server

`apt-get update && apt-get upgrade -y && apt-get install -y git ca-certificates curl \`  
`&& curl -fsSL https://pkgs.zabbly.com/key.asc -o /etc/apt/keyrings/zabbly.asc \`  
`&& chmod a+r /etc/apt/keyrings/zabbly.asc \`  
`&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/zabbly.asc] https://pkgs.zabbly.com/incus/stable $(. /etc/os-release && echo "$VERSION_CODENAME") main" | sudo tee /etc/apt/sources.list.d/zabbly.list > /dev/null \`  
`&& apt-get update && apt-get install -y incus`

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

`for X in {1..3}; do`  
`useradd -d /home/user${X} -m -G users -s /usr/local/bin/incusshell -p $(echo XXXXX-XXXXX | openssl passwd -1 -stdin) user${X}`  
`incus launch images:ubuntu/noble user${X}`  
`done`

`ssh user1@123.123.123.123`

#### cleanup login server
`for X in {1..3}; do`  
`userdel -r user${X}`  
`incus stop user${X}`  
`sleep 2`  
`incus delete user${X}`  
`done`


