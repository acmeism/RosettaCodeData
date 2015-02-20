/*REXX pgm sums all integers from  1──>N─1  that're multiples of 3 or 5.*/
parse arg N t .;       if N==''  then N=1000;      if t==''  then t=1
numeric digits 9999;   numeric digits max(9,20*length(N*10**t))
say 'The sum of all positive integers that are a multiple of 3 and 5 are:'
say                                    /* [↓]  change the look of nE+nn */
      do t;  parse value format(N,2,1,,0) 'E0'   with  y 'E' _ .;    _=_+0
             y=right((m/1)'e'_,5)'-1'  /*allows for a bug in some REXXes*/
             if t==1  then y=N-1       /*handle special case of one-time*/
      sum=sumDivisors(N-1,3) + sumDivisors(N-1,5) - sumDivisors(N-1,3*5)
      say 'integers from  1 ──►'   y   " is "    sum
      N=N*10                           /*multiply by ten for next round.*/
      end   /*t*/
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SUMDIVISORS subroutine──────────────*/
sumDivisors:  procedure;   parse arg x,d;    _=x%d;     return d*_*(_+1)%2
