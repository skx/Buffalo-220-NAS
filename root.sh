#!/bin/sh
#
#  Root a Buffalo NAS
#


#
#  1.  Change the root password
#
./nas "(echo ssh.pass;echo ssh.pass)|passwd"

#
#  2. Enable SFTP and confirm it is done
#
./nas "sed -i 's/SUPPORT_SFTP=0/SUPPORT_SFTP=1/g' /etc/nas_feature"
./nas "grep SFTP /etc/nas_feature"

#
#  3.  Enable Root login, and confirm same.
#
./nas  "sed -i 's/#PermitRootLogin/PermitRootLogin /g' /etc/sshd_config"
./nas "grep Root /etc/sshd_config"

#
#  4. Enable SFTP
#
./nas "/etc/init.d/sshd.sh stop"
./nas "/etc/init.d/sshd.sh start"
