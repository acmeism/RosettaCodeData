/*REXX program congruential generator which simulates the old BSD &  MS */
/*  random number generators.   BSD= 0──►(2**31)-1,   MS= 0──►(2**16)-1 */
numeric digits 20                      /*enough digits for the multiply.*/

  do seed=0  to 1                      /*perform for seed=0  &  seed=1. */
  bsd=seed;      ms=seed;              /*assign SEED to 2 REXX variables*/
  say center('seed='seed,79,'─')       /*display the seed in a title/sep*/

         do j=1  for 20
         jjj=right(j,3)                /*obtain the right-most 3 digits.*/
         bsd =  (1103515245 * bsd   +     12345)    //    2**31
         ms  =  (    214013 *  ms   +   2531011)    //    2**31
         say 'state'   jjj   ' BSD'  right(bsd,11)   left('',18),
                             'MS'    right( ms,11)   left('',5),
                             'rand'  right(ms%2**16,6)
         end   /*j*/
  end          /*seed*/                /*stick a fork in it, we're done.*/
