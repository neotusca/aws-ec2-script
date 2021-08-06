# 1. 기본패치
yum update -y

# 3. 표준시간대 설정
sed -i 's/ZONE="UTC"/ZONE="Asia\/Seoul"/'  /etc/sysconfig/clock 
ln -sf  /usr/share/zoneinfo/Asia/Seoul   /etc/localtime 

# 4. 패키지설치
yum  update    aws-cli -y
yum  install   java-1.8.0-openjdk-devel -y
yum  install   gcc gcc-c++ -y

# 5. 초기설정백업
mkdir -p  /home/ec2-user/security/result
cp /etc/passwd  /home/ec2-user/security/result/etc_passwd.txt
ps -ef | grep -v ps | grep -v grep  >  /home/ec2-user/security/result/ps_list.txt

# 6. 사용자 및 그룹생성
groupadd -g 2000  sysadmingroup
groupadd -g 3000  wasusergroup
groupadd -g 4000  etcusergroup
useradd -u 2001 -g 2000  sysadmin
useradd -u 3001 -g 3000  wasuser
useradd -u 4001 -g 4000  etcuser

# 7. sshd설정
mv /etc/ssh/sshd_config       /etc/ssh/sshd_config.org
cp /etc/ssh/sshd_config.org   /etc/ssh/sshd_config
sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/'      /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/'  /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/'               /etc/ssh/sshd_config
sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/'      /etc/ssh/sshd_config

mv /etc/cloud/cloud.cfg      /etc/cloud/cloud.cfg.org
cp /etc/cloud/cloud.cfg.org  /etc/cloud/cloud.cfg
sed -i 's/ssh_pwauth:   false/ssh_pwauth:   true/'   /etc/cloud/cloud.cfg

# 8. sudo설정
echo "##### added by init-1.sh #####"   >>  /etc/sudoers.d/90-cloud-init-users
echo "sysadmin ALL=(ALL) NOPASSWD:ALL"  >>  /etc/sudoers.d/90-cloud-init-users

# 9. 시스템언어설정
sed -i 's/en_US.UTF-8/ko_KR.utf8/'  /etc/sysconfig/i18n 
echo "##### added by init-1.sh #####"   >>  /etc/bashrc
echo "LANG=ko_KR.utf8"                  >> /etc/bashrc

# 10. AWS ssm agent설치확인
result=`rpm -qa | grep ssm-agent`
if [ ! -z "$result" ]
  then
    echo $result"  installed"
  else
    echo "ssm-agent not installed"
fi  

# 11. AWS cloudwatch agent설치
yum install amazon-cloudwatch-agent  -y
cp cloudwatch-agent-config.json  /opt/aws/amazon-cloudwatch-agent/bin/config.json
mkdir /usr/share/collectd
touch /usr/share/collectd/types.db
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file://opt/aws/amazon-cloudwatch-agent/bin/config.json -s
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a status


