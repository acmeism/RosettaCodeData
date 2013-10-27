/*REXX pgm sums the digits of natural numbers in any base up to base 36.*/
parse arg z                            /*get optional #s or use default.*/
if z=''  then z='1 1234 fe f0e +F0E -666.00 11111112222222333333344444449'
     do j=1  for words(z);     _=word(z,j)
     say right(sumDigs(_),9) ' is the sum of the digits for the number ' _
     end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SUMDIGS subroutine──────────────────*/
sumDigs: procedure;    arg x;        @=123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ
s=0;                do k=1  for length(x);        s=s+pos(substr(x,k,1),@)
                    end   /*k*/
return s
