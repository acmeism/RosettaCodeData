/*REXX program displays numbers  1 ──► 100  (some transformed) for the FizzBuzz problem.*/
                                                 /*╔═══════════════════════════════════╗*/
  do j=1  to 100                                 /*║                                   ║*/
      select                                     /*║                                   ║*/
      when j//15==0  then say 'FizzBuzz'         /*║ The divisors  (//)  of the  WHENs ║*/
      when j//5 ==0  then say '    Buzz'         /*║ must be in  descending  order.    ║*/
      when j//3 ==0  then say '    Fizz'         /*║                                   ║*/
      otherwise           say right(j, 8)        /*╚═══════════════════════════════════╝*/
      end   /*select*/
  end       /*j*/                                /*stick a fork in it,  we're all done. */
