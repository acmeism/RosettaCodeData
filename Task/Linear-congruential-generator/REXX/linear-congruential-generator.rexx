/*REXX program uses a linear congruential generator (LCG)  that simulates the old  BSD  */
/*──────── and MS random number generators:    BSD= 0──►(2^31)-1     MS= 0──►(2^16)-1   */
numeric digits 20                                /*use enough dec. digs for the multiply*/
two@@16= 2**16                                   /*use a variable to contain  2^16      */
two@@31= 2**31                                   /* "  "     "     "    "     2^32      */

        do seed=0  for 2;       bsd= seed        /*perform for seed=0  and also  seed=1.*/
                                 ms= seed        /*assign  SEED  to  two REXX variables.*/
        say center(' seed='seed" ", 79, '─')     /*display the seed in a title/separator*/
                                                 /* [↓]  show 20 rand #'s for each seed.*/
            do j=1  for 20                       /*generate & display 20 random numbers.*/

            bsd = (1103515245 * bsd   +     12345)   //    two@@31
            ms  = (    214013 *  ms   +   2531011)   //    two@@31
                                                 /*  ↑                                  */
                                                 /*  └─────◄──── REXX remainder operator*/

            say '  state'   right(j,3)   " BSD"   right(bsd,     11)   left('', 13),
                                         " MS"    right( ms,     11)   left('',  5),
                                         " rand"  right(ms % two@@16,  6)
            end   /*j*/
        end       /*seed*/                       /*stick a fork in it,  we're all done. */
