LIST='20 20 2';
SUM=0; PROD=1;
for i in $LIST; do
  SUM=$[$SUM + $i]; PROD=$[$PROD * $i];
done;
echo $SUM $PROD
