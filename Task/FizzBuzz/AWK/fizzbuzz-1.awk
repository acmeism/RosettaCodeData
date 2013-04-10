BEGIN {
   for (NUM=1; NUM<=100; NUM++)
       if (NUM % 15 == 0)
           {print "FizzBuzz"}
       else if (NUM % 3 == 0)
           {print "Fizz"}
       else if (NUM % 5 == 0)
           {print "Buzz"}
       else
           {print NUM}
}
