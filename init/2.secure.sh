#!/bin/bash

NOW=`date '+%Y.%m.%d %H:%M:%S'`





### 계정관리

DIR=/etc/pam.d
FILE1=system-auth

mv  $DIR/$FILE1      $DIR/$FILE1.org
cp  $DIR/$FILE1.org  $DIR/$FILE1
sed -i 's/required      pam_env.so$/required      pam_env.so\r\nauth        required      pam_tally2.so  deny=5 unlock_time=120 no_magic_root reset/'  $DIR/$FILE1
sed -i 's/authtok_type=$/authtok_type=minlen=8 dcredit=-1 ucredit=-1 lcredit=-1 ocredit=-1/'   $DIR/$FILE1
echo "### secured by mzc at "$NOW  >>  $DIR/$FILE1




