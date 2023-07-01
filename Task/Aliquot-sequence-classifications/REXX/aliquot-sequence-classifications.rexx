/*REXX program classifies various  positive integers  for  types of  aliquot sequences. */
parse arg low high $L                            /*obtain optional arguments from the CL*/
high= word(high low 10,1);   low= word(low 1,1)  /*obtain the  LOW  and  HIGH  (range). */
if $L=''  then $L=11 12 28 496 220 1184 12496 1264460 790 909 562 1064 1488 15355717786080
numeric digits 100                               /*be able to compute the number:  BIG  */
big= 2**47;                  NTlimit= 16 + 1     /*limits for a non─terminating sequence*/
numeric digits max(9, length(big) )              /*be able to handle big numbers for // */
digs= digits()                                   /*used for align numbers for the output*/
#.= .;        #.0= 0;        #.1= 0              /*#.   are the proper divisor sums.    */
say center('numbers from '      low      " ───► "      high      ' (inclusive)', 153, "═")
          do n=low  to high;    call classify  n /*call a subroutine to classify number.*/
          end   /*n*/                            /* [↑]   process a range of integers.  */
say
say center('first numbers for each classification', 153, "═")
class.= 0                                        /* [↓]  ensure one number of each class*/
          do q=1  until class.sociable\==0       /*the only one that has to be counted. */
          call classify  -q                      /*minus (-) sign indicates don't tell. */
          _= what;  upper _                      /*obtain the class and uppercase it.   */
          class._= class._ + 1                   /*bump counter for this class sequence.*/
          if class._==1  then say right(q, digs)':'      center(what, digs)      $
          end   /*q*/                            /* [↑]  only display the 1st occurrence*/
say                                              /* [↑]  process until all classes found*/
say center('classifications for specific numbers', 153, "═")
          do i=1  for words($L)                  /*$L:  is a list of  "special numbers".*/
          call classify   word($L, i)            /*call a subroutine to classify number.*/
          end   /*i*/                            /* [↑]  process a list of integers.    */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
classify: parse arg a 1 aa;         a= abs(a)    /*obtain number that's to be classified*/
       if #.a\==.    then s= #.a                 /*Was this number been  summed  before?*/
                     else s= sigma(a)            /*No, then classify number the hard way*/
       #.a= s                                    /*define sum of the  proper divisors.  */
       $= s                                      /*define the start of integer sequence.*/
                     what= 'terminating'         /*assume this kind of classification.  */
       c.=  0                                    /*clear all cyclic sequences (to zero).*/
       c.s= 1                                    /*set the first cyclic sequence.       */
       if $==a  then what= 'perfect'             /*check for a  "perfect"  number.      */
                else do t=1  while s>0           /*loop until sum isn't  0   or   > big.*/
                     m= s                        /*obtain the last number in sequence.  */
                     if #.m==.  then s= sigma(m) /*Not defined? Then sum proper divisors*/
                                else s= #.m      /*use the previously found integer.    */
                     if m==s  then if m>=0   then do;  what= 'aspiring';  leave;   end
                     parse var  $   .  word2  .  /*obtain the 2nd  number in sequence.  */
                     if word2==a             then do;  what= 'amicable';  leave;   end
                     $= $ s                      /*append a sum to the integer sequence.*/
                     if s==a  then if t>3    then do;  what= 'sociable';  leave;   end
                     if c.s   then if m>0    then do;  what= 'cyclic'  ;  leave;   end
                     c.s= 1                      /*assign another possible cyclic number*/
                                                 /* [↓]  Rosetta Code task's limit: >16 */
                     if t>NTlimit     then do;  what= 'non─terminating';  leave;   end
                     if s>big         then do;  what= 'NON─TERMINATING';  leave;   end
                     end   /*t*/                 /* [↑]  only permit within reason.     */
       if aa>0  then say right(a, digs)':'     center(what, digs)     $
       return                                    /* [↑] only display if  AA  is positive*/
/*──────────────────────────────────────────────────────────────────────────────────────*/
sigma: procedure expose #. !.;  parse arg x;   if 11<2  then return 0;        odd= x // 2
       s= 1                                      /* [↓]  use EVEN or ODD integers.   ___*/
            do j=2+odd  by 1+odd  while j*j<x    /*divide by all the integers up to √ X */
            if x//j==0  then  s= s + j +   x % j /*add the two divisors to the sum.     */
            end   /*j*/                          /* [↓]  adjust for square.          ___*/
       if j*j==x  then  s= s + j                 /*Was  X  a square?    If so, add  √ X */
       #.x= s                                    /*memoize division sum for argument  X.*/
       return s                                  /*return      "     "   "      "     " */
