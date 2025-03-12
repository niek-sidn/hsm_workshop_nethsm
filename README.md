# hsm_workshop_nethsm

Maak EQX host aan met:
  Ubuntu Noble
  hostname centr-dublin01
  tags: Niek, CENTR, NetHSM
  1 public ip4, geen public ip6, /31 private ip4

Laptop:
export IP=147.28.221.5  #(bijvoorbeeld)

Na 10m:
ssh -l root -o UserKnownHostsFile=/dev/null -o "StrictHostKeyChecking no" -o "LogLevel ERROR" ${IP}

apt-get update && apt-get upgrade -y && apt-get install -y git ca-certificates curl \
&& curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc \
&& chmod a+r /etc/apt/keyrings/docker.asc \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null \
&& apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
&& systemctl enable --now docker

git clone https://<PAT>@github.com/niek-sidn/hsm_workshop_nethsm.git

cd hsm_workshop_nethsm
rm -rf files/nitrokey-nethsm/data
vim files/hsm-client/hsm_env_vars
  edit the "export API=" line so it has the right ip
docker compose up -d --build
docker compose logs

docker compose exec -it hsm-client bash
curl $CURLOPTS --user "admin:$ADMINPASS" -X GET $API/users -H 'accept: application/json' | jq .
curl $CURLOPTS --user "admin:$ADMINPASS" -X GET $API/namespaces -H 'accept: application/json' | jq .
