# Info
* Remote state : terraform.tfstate파일을 원격 저장소인 s3에 저장하는 예


# 실행 절차
1. 폴더로 이동
```
cd terraform-course/07-Outputting
```
* 주의 private_ips.txt 파일 있으면 지울 것

2. S3 Bucket 생성
   * aws → Service → S3 → Create Bucket → Bucket Name(unique하게)
   * 만들어진 bucket의 Properties(속성)에서 Versioning을 enable할것.(보안 셋팅을 Public으로 바꿀 필요 없음.)

3. 위2번에서 만든 S3 Bucket name을 소스코드에 입력
```
vi backend.tf
# bucket = "xxxxx"  → bucket = "<S3 버킷이름>"
```
* 주의 : "aws configure" 셋팅 필수임(terraform에서 aws 명령으로 s3에 접근함)

2. init 및 apply
```
terraform init
terraform apply -auto-approve
```


4. Instance 생성 확인 및 원격스크립트 실행 확인
```
cat terraform.tfstate|grep public_ip
cat script.sh
ssh -i ~/mykey ubuntu@<ip> hostname
curl <ip>
```

6. destroy
```
terraform destroy -auto-approve
aws ec2 delete-key-pair --key-name mykey

```
