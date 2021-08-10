#!/bin/bash

NOW=`date '+%Y.%m.%d %H:%M:%S'`


# U-1
FILE1=/etc/pam.d/system-auth
mv  $FILE1      $FILE1.org
cp  $FILE1.org  $FILE1
sed -i 's/required      pam_env.so$/required      pam_env.so\nauth        required      pam_tally2.so  deny=5 unlock_time=120 no_magic_root reset/'  $FILE1
sed -i 's/authtok_type=$/authtok_type=minlen=8 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1/'  $FILE1
echo "### secured by mzc at "$NOW  >>  $FILE1


# U-2
FILE2=/etc/login.defs
mv  $FILE2      $FILE2.org
cp  $FILE2.org  $FILE2
sed -i 's/PASS_MAX_DAYS\t99999/PASS_MAX_DAYS\t90/g' /etc/login.defs
sed -i 's/PASS_MIN_DAYS\t0/PASS_MIN_DAYS\t1/g'      /etc/login.defs
sed -i 's/PASS_MIN_LEN\t5/PASS_MIN_LEN\t8/g'        /etc/login.defs
sed -i 's/PASS_WARN_AGE\t7/PASS_WARN_AGE\t7/g'      /etc/login.defs
echo "### secured by mzc at "$NOW  >>  $FILE2

FILE2=/etc/shadow
USERS="sysadmin wasuser etcuser"
for USER in $USERS
do
    echo [$USER]
    if [ ! -z `awk -F: '$5!=90  {print $1":"$5}' $FILE2 | grep $USER` ]
    then
        awk -F: '$5!=90  {print $1":"$5" --> "$1":"90}' $FILE2 | grep $USER 
        awk -F: '$5!=90  {print $1":"$5}' $FILE2 | grep $USER | sed -i 's/99999/90/' $FILE2
    fi
done


# U-3 
FILE3=/etc/pam.d/sshd
mv  $FILE3      $FILE3.org
cp  $FILE3.org  $FILE3
sed -i 's/^auth       required     pam_sepermit.so$/^auth       required     pam_sepermit.so\nauth        required      pam_tally2.so  deny=5 unlock_time=120 no_magic_root reset/'  $FILE3
echo "### secured by mzc at "$NOW  >>  $FILE3


# U-6
FILE6=/usr/bin/su
stat  $FILE6
chmod 4750  $FILE6

FILE6=/etc/pam.d/su
mv  $FILE6      $FILE6.org
cp  $FILE6.org  $FILE6
sed -i 's/#auth		required	pam_wheel.so use_uid/auth		required	pam_wheel.so use_uid/'  $FILE6
echo "### secured by mzc at "$NOW  >>  $FILE6


# U-12
FILE15=/etc/group
sed -i '/dialout:x:18:/d'     $FILE15
sed -i '/tape:x:33:/d'        $FILE15
sed -i '/video:x:39:/d'       $FILE15
sed -i '/audio:x:63:/d'       $FILE15
sed -i '/utmp:x:22:/d'        $FILE15
sed -i '/utempter:x:35:/d'    $FILE15
sed -i '/slocate:x:21:/d'     $FILE15
sed -i '/postdrop:x:90:/d'    $FILE15
sed -i '/stapusr:x:156:/d'    $FILE15
sed -i '/stapsys:x:157:/d'    $FILE15
sed -i '/stapdev:x:158:/d'    $FILE15
sed -i '/ftp:x:50:/d'         $FILE15
sed -i '/ssh_keys:x:998:/d'   $FILE15


# U-15
FILE15=/etc/bashrc
echo "### secured by mzc ###"  >> $FILE15
echo "export TMOUT=600"  >> $FILE15


# U-20
FILE20=/etc/hosts
stat  $FILE20
chmod 600  $FILE20


# U-24
FILE24=/usr/bin/newgrp
stat $FILE24
chmod -s $FILE24
FILE24=/sbin/unix_chkpwd
stat $FILE24
chmod -s $FILE24
FILE24=/usr/bin/at
stat $FILE24
chmod -s $FILE24


# U-34
FILE34=/etc/passwd
sed -i '/ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin/d'                                   $FILE34
sed -i '/rngd:x:998:996:Random Number Generator Daemon:/var/lib/rngd:/sbin/nologin/d'     $FILE34


# U-44
SVC44_1=rpcbind
SVC44_2=postfix
systemctl  status  $SVC44_1
systemctl  stop    $SVC44_1
systemctl  disable $SVC44_1
systemctl  status  $SVC44_2
systemctl  stop    $SVC44_2
systemctl  disable $SVC44_2


# U-64
FILE64=/etc/at.deny
stat $FILE64
chmod 640 $FILE64


# U-67
FILE67_1=/etc/update-motd.d/30-banner
FILE67_2=/etc/motd
FILE67_3=/etc/issue
FILE67_4=/etc/issue.net

echo "*******************************************************************************************************"  >> $FILE67_3
echo "*                                                                                                     *"  >> $FILE67_3
echo "*  This server is the property of XXXXXX Industries and only allows authorized users access. *"  >> $FILE67_3
echo "*  Users who delete/modify/distribute information by illegally accessing or misusing the server       *"  >> $FILE67_3
echo "*  may be punished according to relevant regulations.                                                 *"  >> $FILE67_3
echo "*                                                                                                     *"  >> $FILE67_3
echo "*  본 서버는 XXXXXX의 자산이며 인증된 사용자 에게만 접근을 허가 합니다.                           *"  >> $FILE67_3
echo "*  서버에 불법적으로 접근하거나 오용하여 정보를 삭제/변경/배포하는 사용자는                           *"  >> $FILE67_3
echo "*  관련 규정에 따라 처벌을 받을 수 있습니다.                                                          *"  >> $FILE67_3
echo "*                                                                                                     *"  >> $FILE67_3
echo "*******************************************************************************************************"  >> $FILE67_3







##########################################################################################
# 대상파일
# U-2:/etc/shadow                 - sysadmin,wasuser,etcuser  90일처리
# U-3:/etc/pam.d/system-auth      - 추가 설정
# U-4:/etc/passwd         -
# U-5:/etc/passwd         -
# U-10:/etc/passwd                - ec2-user,ssm-user,cwagent,sysadmin,wasuser,etcuser
# U-11:/etc/group
# U-22:/etc/rsyslog.conf
