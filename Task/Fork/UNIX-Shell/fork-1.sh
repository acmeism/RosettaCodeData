i=0
(while test $i -lt 10; do
  sleep 1
  echo "Child process"
  i=`expr $i + 1`
done) &
while test $i -lt 5; do
  sleep 2
  echo "Parent process"
  i=`expr $i + 1`
done
