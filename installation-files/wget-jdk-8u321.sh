#!/bin/sh

#
# Generated on Tue Feb 15 03:56:19 PST 2022
# Start of user configurable variables
#
LANG=C
export LANG

#Trap to cleanup cookie file in case of unexpected exits.
trap 'rm -f $COOKIE_FILE; exit 1' 1 2 3 6

# SSO username
printf 'SSO User Name:'
read SSO_USERNAME

# Path to wget command
WGET=/usr/bin/wget

# Log directory and file
LOGDIR=.
LOGFILE=$LOGDIR/wgetlog-$(date +%m-%d-%y-%H:%M).log

# Print wget version info
echo "Wget version info:
------------------------------
$($WGET -V)
------------------------------" > "$LOGFILE" 2>&1

# Location of cookie file
COOKIE_FILE=$(mktemp -t wget_sh_XXXXXX) >> "$LOGFILE" 2>&1
if [ $? -ne 0 ] || [ -z "$COOKIE_FILE" ]
then
 echo "Temporary cookie file creation failed. See $LOGFILE for more details." |  tee -a "$LOGFILE"
 exit 1
fi
echo "Created temporary cookie file $COOKIE_FILE" >> "$LOGFILE"

# Output directory and file
OUTPUT_DIR=.
#
# End of user configurable variable
#

# The following command to authenticate uses HTTPS. This will work only if the wget in the environment
# where this script will be executed was compiled with OpenSSL.
#
 $WGET  --secure-protocol=auto --save-cookies="$COOKIE_FILE" --keep-session-cookies --http-user "$SSO_USERNAME" --ask-password  "https://edelivery.oracle.com/osdc/cliauth" -O /dev/null 2>> "$LOGFILE"

# Verify if authentication is successful
if [ $? -ne 0 ]
then
 echo "Authentication failed with the given credentials." | tee -a "$LOGFILE"
 echo "Please check logfile: $LOGFILE for more details."
else
 echo "Authentication is successful. Proceeding with downloads..." >> "$LOGFILE"
 $WGET --load-cookies="$COOKIE_FILE" "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V1019120-01.zip&token=bGx5Z1BrejMvbTZPcjd2N21oTzhkQSE6OiFmaWxlSWQ9MTEzNzIyNTk1JmZpbGVTZXRDaWQ9MTA3NTE2NyZyZWxlYXNlQ2lkcz0xMDYyNzk2JnBsYXRmb3JtQ2lkcz0zNSZkb3dubG9hZFR5cGU9OTU3NjEmYWdyZWVtZW50SWQ9ODIyMzc5NCZlbWFpbEFkZHJlc3M9ZHBlY2hAdS1zbHVuby5jeiZ1c2VyTmFtZT1FUEQtRFBFQ0hAVS1TTFVOTy5DWiZpcEFkZHJlc3M9MjEzLjE5NS4yMTcuMTU3JnVzZXJBZ2VudD1Nb3ppbGxhLzUuMCAoTWFjaW50b3NoOyBJbnRlbCBNYWMgT1MgWCAxMF8xNV83KSBBcHBsZVdlYktpdC82MDUuMS4xNSAoS0hUTUwsIGxpa2UgR2Vja28pIFZlcnNpb24vMTUuMSBTYWZhcmkvNjA1LjEuMTUmY291bnRyeUNvZGU9Q1o" -O "$OUTPUT_DIR/V1019120-01.zip" >> "$LOGFILE" 2>&1
fi

# Cleanup
rm -f "$COOKIE_FILE"
echo "Removed temporary cookie file $COOKIE_FILE" >> "$LOGFILE"