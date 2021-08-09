#!/bin/bash

NOW=`date '+%Y.%m.%d %H:%M:%S'`


FILE1=/etc/security/limits.conf
mv  $FILE1      $FILE1.org
cp  $FILE1.org  $FILE1
echo "### adjusted by mzcloud at "$NOW  >>  $FILE1
echo "@was             soft    nofile          8192"          >>  $FILE1
echo "@was             hard    nofile          65535"         >>  $FILE1
echo "@was             soft    nproc           8192"          >>  $FILE1
echo "@was             hard    nproc           65535"         >>  $FILE1
echo "@was             -       memlock         125829120"     >>  $FILE1
echo "@was             -       stack           unlimited"     >>  $FILE1
echo "@was             -       core            unlimited"     >>  $FILE1
echo ""                                                       >>  $FILE1
echo "*                soft    nofile          8192"          >>  $FILE1
echo "*                hard    nofile          65535"         >>  $FILE1
echo "*                soft    nproc           4096"          >>  $FILE1
echo "*                hard    nproc           65535"         >>  $FILE1
echo "*                soft    core            10485760"      >>  $FILE1


FILE2=99-mzcloud.conf
cp  $FILE2   /etc/sysctl.d/
sysctl -p  /etc/sysctl.d/$FILE2

