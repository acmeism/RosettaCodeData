/*REXX pgm sums all integers from  1 ──► N─1  that are multiples of  3  or  5.*/
parse arg N t .;       if N==''  then N=1000;      if t==''  then t=1
numeric digits 9999;   numeric digits max(9,20*length(N*10**t))
say 'The sum of all positive integers that are a multiple of 3 and 5 are:'
say                                    /* [↓]  change the format/look of nE+nn*/
      do t;  parse value format(N,2,1,,0) 'E0'   with   m 'E' _ .;       _=_+0
      y=right((m/1)'e'_,5)'-1'         /*this fixes a bug in a certain REXX.  */
      if t==1  then y=N-1              /*handle a special case of a one-timer.*/
      sum=sumDivisors(N-1, 3)   +  sumDivisors(N-1, 5)  -  sumDivisors(N-1, 3*5)
      say 'integers from  1 ──►'      y      " is "        sum
      N=N*10                           /*multiply by ten for the next round.  */
      end   /*t*/
exit                                   /*stick a fork in it,  we're all done. */
/*────────────────────────────────────────────────────────────────────────────*/
sumDivisors:  procedure;   parse arg x,d;      _=x%d;         return d*_*(_+1)%2
