/*REXX program displays numbers  1 ──► 100  for the  FizzBuzz  problem. */

 do n=1  for 100
    select                             /*╔═════════════════════════════╗*/
    when n//15==0  then say 'FizzBuzz' /*║ The  WHENs  must be in      ║*/
    when n//5 ==0  then say '    Buzz' /*║             descending order║*/
    when n//3 ==0  then say '    Fizz' /*╚═════════════════════════════╝*/
    otherwise           say right(n,8)
    end   /*select*/
 end       /*n*/                       /*stick a fork in it, we're done.*/
