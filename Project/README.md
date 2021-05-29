# Info
* ELB를 구현하고 Load Balancer가 작동하는지 확인하는 예

# 실행 절차
1. 폴더로 이동
```
cd terraform-course/Project
```

2. init 및 apply
```
terraform init
terraform apply -auto-approve
```


3. ELB 작동 여부와 Instance 확인
```
# ELB 작동여부 확인
dns_names=$(cat terraform.tfstate|grep dns_name|awk 'BEGIN{FS="\""}{print$4}')
for dns_name in $dns_names; do
    echo $dns_name --------------------
    curl $dns_name
    curl $dns_name
    curl $dns_name
done


# Instance Name과 InstanceId 확인
aws ec2 describe-instances     --filters Name=instance-state-name,Values=running     --query 'Reservations[*].Instances[].[InstanceId, Tags[?Key==`Name`]]' --output text

# 각 Instance 작동 확인
ec2Ids=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running" --query "Reservations[].Instances[].InstanceId" --output text)
for i in $ec2Ids; do
  echo Instance Id : $i
  ip=$(aws ec2 describe-instances --instance-ids $i --query 'Reservations[*].Instances[*].PublicIpAddress' --output text)
  echo "ssh -i ~/mykey ubuntu@$ip hostname"
  ssh -i ~/mykey ubuntu@$ip hostname
done
```

4. destroy
```
terraform destroy -auto-approve
aws ec2 delete-key-pair --key-name prjkey

```


# ToDo
* Security Group이 현재는 모두 열려 있는 상태, zone별로 통신 가능하게 할 것. 
