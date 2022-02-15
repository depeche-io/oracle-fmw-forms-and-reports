#!/bin/sh

#
# Generated on Tue Feb 15 06:26:05 PST 2022
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
 $WGET  --load-cookies="$COOKIE_FILE" --save-cookies="$COOKIE_FILE" --keep-session-cookies "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V983392-01_1of2.zip&token=MW1FdkR1RXlySktBTWQ2eHpMK0tNUSE6OiFmaWxlSWQ9MTA1ODAwNDY1JmZpbGVTZXRDaWQ9OTEyMTQ0JnJlbGVhc2VDaWRzPTg0NzgxOCZwbGF0Zm9ybUNpZHM9MzUmZG93bmxvYWRUeXBlPTk1NzYwJmFncmVlbWVudElkPTgyMjQxNjYmZW1haWxBZGRyZXNzPWRwZWNoQHUtc2x1bm8uY3omdXNlck5hbWU9RVBELURQRUNIQFUtU0xVTk8uQ1omaXBBZGRyZXNzPTIxMy4xOTUuMjE3LjE1NyZ1c2VyQWdlbnQ9TW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTVfNykgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzE1LjEgU2FmYXJpLzYwNS4xLjE1JmNvdW50cnlDb2RlPUNaJmRscENpZHM9OTE0NTM0" -O "$OUTPUT_DIR/V983392-01_1of2.zip" >> "$LOGFILE" 2>&1
 $WGET --load-cookies="$COOKIE_FILE" "https://edelivery.oracle.com/osdc/softwareDownload?fileName=V983392-01_2of2.zip&token=YXpCaGp3VERLejFVVEYzZjRjSnRVdyE6OiFmaWxlSWQ9MTA1ODAwNDY2JmZpbGVTZXRDaWQ9OTEyMTQ0JnJlbGVhc2VDaWRzPTg0NzgxOCZwbGF0Zm9ybUNpZHM9MzUmZG93bmxvYWRUeXBlPTk1NzYwJmFncmVlbWVudElkPTgyMjQxNjYmZW1haWxBZGRyZXNzPWRwZWNoQHUtc2x1bm8uY3omdXNlck5hbWU9RVBELURQRUNIQFUtU0xVTk8uQ1omaXBBZGRyZXNzPTIxMy4xOTUuMjE3LjE1NyZ1c2VyQWdlbnQ9TW96aWxsYS81LjAgKE1hY2ludG9zaDsgSW50ZWwgTWFjIE9TIFggMTBfMTVfNykgQXBwbGVXZWJLaXQvNjA1LjEuMTUgKEtIVE1MLCBsaWtlIEdlY2tvKSBWZXJzaW9uLzE1LjEgU2FmYXJpLzYwNS4xLjE1JmNvdW50cnlDb2RlPUNaJmRscENpZHM9OTE0NTM0" -O "$OUTPUT_DIR/V983392-01_2of2.zip" >> "$LOGFILE" 2>&1
fi

# Cleanup
rm -f "$COOKIE_FILE"
echo "Removed temporary cookie file $COOKIE_FILE" >> "$LOGFILE"
