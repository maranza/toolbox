DST1=/Volumes/myfiles/
DST2=/Volumes/FILESHARING/
SRV1=bikette01.ipsyn.net
SSH_USERNAME=bikette
SAVING_FILENAME=$1
MAILTO=$2

echo $SAVING_FILENAME
if [ -f $DST1 ]
then
  cp -f $SAVING_FILENAME $DST1
  result1=OK
else
  result1=KO
fi
if [ -f $DST2 ]
then
    cp -f $SAVING_FILENAME $DST2
    result2=OK
  else
    result2=KO
fi

ssh -q $SSH_USERNAME@$SRV1 exit
if [ $? -eq 0 ]
then
  scp $SAVING_FILENAME $SSH_USERNAME@$SRV1:backup/.
  result3=OK
else
  result3=KO
fi

if [ $result1 = $result2 ] && [ $result1 = $result3 ] && [ $result1 = KO ]
then
  subject="File $SAVING_FILENAME not saved"
  body="Could not save $SAVING_FILENAME, no saving location available"
  echo  $body | mail -s "$subject" $MAILTO
fi
