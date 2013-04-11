/*REXX pgm sums the digits of natural numbers in any base up to base 36.*/
parse arg nums;    if nums=''  then nums='1 1234 fe f0e +F0E -666.00'
        do j=1  for words(nums);   _=word(nums,j)
        say right(sumDigs(_),9) ' is the sum of the digits for the number
        end   /*j*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SUMDIGS subroutine──────────────────*/
sumDigs: procedure;    arg x;      @='123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'
s=0;                do i=1  for length(x)
                    s=s+index(@,substr(x,i,1))
                    end   /*i*/
return s
