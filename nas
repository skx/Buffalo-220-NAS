#!/bin/sh
#
# This script executes commands on the NAS, and requires that
# you configure the two details:
#
#  1.  The IP address of the NAS
#
#  2.  The password for the "admin" user.
#


IP=10.0.0.108

ADMIN_PASS=Pah7zo3echae

java -jar acp_commander.jar  -q -t ${IP} -ip ${IP} -pw ${ADMIN_PASS} -c "$*"
