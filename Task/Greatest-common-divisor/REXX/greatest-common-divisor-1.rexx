/*REXX pgm finds GCD (Greatest Common Divisor) of any number of integers*/
numeric digits 2000                    /*handle up to  2K digit numbers.*/
call gcd 0 0            ;       call gcd 55 0     ;       call gcd 0    66
call gcd 7,21           ;       call gcd 41,47    ;       call gcd 99 , 51
call gcd 24, -8         ;       call gcd -36, 9   ;       call gcd -54, -6
call gcd 14 0 7         ;       call gcd 14 7 0   ;       call gcd 0  14 7
call gcd 15 10 20 30 55 ;       call gcd 137438691328  2305843008139952128  /*◄──two perfect numbers.*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────GCD subroutine──────────────────────*/
gcd: procedure; $=;   do i=1 for arg();  $=$ arg(i);  end    /*arg list.*/
parse var $ x z .;  if x=0 then x=z;  x=abs(x)  /*handle special 0 case.*/

   do j=2  to words($);   y=abs(word($,j));       if y=0  then iterate
     do until _==0;  _=x//y;  x=y;  y=_;  end   /*◄── the heavy lifting.*/
   end   /*j*/

say 'GCD (Greatest Common Divisor) of '   translate(space($),",",' ')   "  is  "   x
return x
