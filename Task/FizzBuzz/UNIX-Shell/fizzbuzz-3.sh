NUM=1
until ((NUM == 101)) ; do
   if ((NUM % 15 == 0)) ; then
       echo FizzBuzz
   elif ((NUM % 3 == 0)) ; then
       echo Fizz
   elif ((NUM % 5 == 0)) ; then
       echo Buzz
   else
       echo "$NUM"
   fi
   ((NUM = NUM + 1))
done
