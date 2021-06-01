# Kubernetes Install With Kubespray

1. Hosts파일 셋팅
```
ec2IdsAndName=$(aws ec2 describe-instances     --filters Name=instance-state-name,Values=running     --query 'Reservations[*].Instances[].[InstanceId, Tags[?Key==`Name`]]' --output text|sed -z  "s/\\nName[[:blank:]]/,/g")
for i in $ec2IdsAndName; do
	  ec2id=$(echo $i|awk 'BEGIN{FS=","}{printf $1}')
	  ec2Name=$(echo $i|awk 'BEGIN{FS=","}{printf $2}')
    ip=$(aws ec2 describe-instances --instance-ids $ec2id --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
    echo  $ip  $ec2Name
    sudo bash -c "echo  $ip  $ec2Name  >> /etc/hosts"

done
```
* cf) 아래와 같이 /etc/hosts파일 셋팅 해도 됨
```
52.213.183.141 vm01
54.75.118.15   vm02
54.75.118.154  vm03
```

2. git Clone
```
cd
git clone https://github.com/kubernetes-sigs/kubespray
```

3. OS key 생성 [있으면 생략]
```
ssh-keygen -f ~/.ssh/id_rsa -N ''
```
* cf) 설치 대상 host에 Public-key 배포
    ssh-copy-id root@10.0.2.10

3. git clone 및 inventory파일 생성
```
cd kubespray
cat > inventory/inventory.ini  <<EOF
[all]
vm01 etcd_member_name=etcd1
vm02 etcd_member_name=etcd2
vm03 etcd_member_name=etcd3

[kube-master]
vm01
vm02

[etcd]
vm01
vm02
vm03

[kube-node]
vm01
vm02
vm03

[k8s-cluster:children]
kube-master
kube-node

EOF
```

4. kubesparyInstall.sh 실행
```
 wget https://gist.githubusercontent.com/nowage/a169b11372bf6a708bcb475d606471e2/raw/daa0fef590005ed5a70641e996c3c7f5a1a81972/k8sInstallByKubesray.sh
bash k8sInstallByKubesray.sh
```
* ==
```
if [ ! -f requirements.txt ]; then
    echo "go to kubespray install folder"
else
    sudo pip3 install -r requirements.txt
    sudo pip3  install ansible netaddr jinja2

    #declare -a IPS=$(cat /etc/hosts|grep vm|awk '{printf $1 " "}')
    #CONFIG_FILE=inventory/host.yaml python3 ./contrib/aws_inventory/kubespray-aws-inventory.py ${IPS[@]}

    ansible-playbook --flush-cache -u ubuntu -b --become --become-user=root \
      -i inventory/inventory.ini  \
      cluster.yml
fi
```

# Admin
## Shutdown All Instance
```
for i in $(seq 3); do ssh vm0$i sudo sh -c 'shutdown -h now'; done
```
## Startup all Instance
```
ids=$(aws ec2 describe-instances  --filters "Name=tag-value,Values=vm0*" --query "Reservations[].Instances[].InstanceId" --output text)
for i in $ids; do     aws ec2 start-instances --instance-ids $i ;done
```
