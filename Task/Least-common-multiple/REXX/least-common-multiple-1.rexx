/*REXX pgm finds  LCM (Least Common Multiple) of any number of integers.*/
numeric digits 10000                   /*can handle 10,000 digit numbers*/
say 'the LCM of  19  &   0            is: '    lcm(19   0)
say 'the LCM of   0  &  85            is: '    lcm( 0  85)
say 'the LCM of  14  &  -6            is: '    lcm(14, -6)
say 'the LCM of  18  &  12            is: '    lcm(18  12)
say 'the LCM of  18  &  12  & -5      is: '    lcm(18  12,    -5)
say 'the LCM of  18  &  12  & -5 & 97 is: '    lcm(18, 12,    -5,   97)
say 'the LCM of  2**19-1  &  2**521-1 is: '    lcm(2**19-1    2**521-1)
                                       /* [↑]  7th, 13th Mersenne primes*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────LCM subroutine──────────────────────*/
lcm: procedure; parse arg $,_; $=$ _;    do i=3  to arg(); $=$ arg(i); end
parse var $ x $                        /*obtain the first value in args.*/
x=abs(x)                               /*use the absolute value of  X.  */
          do  while $\==''             /*process the remainder of args. */
          parse var $ ! $;   !=abs(!)  /*pick off the next arg (ABS val)*/
          if !==0  then return 0       /*if zero, then LCM is also zero.*/
          d=x*!                        /*calculate part of the LCM here */
                 do  until !==0;  parse  value   x//!  !   with   !  x
                 end   /*until*/       /* [↑]  this is a short&fast GCD.*/
          x=d%x                        /*divide the pre─calculated value*/
          end   /*while*/              /* [↑]  process subsequent args. */
return x                               /*return with the LCM of the args*/
