echo {1..100} | awk '
BEGIN{RS=" "}
$1 % 15 == 0 {print "FizzBuzz"}
$1 % 5 == 0 {print "Buzz"}
$1 % 3 == 0 {print "Fizz"}
{print}
'
