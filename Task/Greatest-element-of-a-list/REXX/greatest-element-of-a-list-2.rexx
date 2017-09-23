/*REXX program finds the  greatest element  in a list (of the first 25 reversed primes).*/
@.=;       @.1 = 2;    @.2 = 3;    @.3 = 5;    @.4 = 7;    @.5 =11;    @.6 =31;    @.7 =71
           @.8 =91;    @.9 =32;    @.10=92;    @.11=13;    @.12=73;    @.13=14;    @.14=34
           @.15=74;    @.16=35;    @.17=95;    @.18=16;    @.19=76;    @.20=17;    @.21=37
           @.22=97;    @.23=38;    @.24=98;    @.25=79
big=@.1                                          /*choose an initial biggest number.    */
                do #=2  while @.#\==''           /*traipse through whole array of nums. */
                big = max(big, @.#)              /*use a BIF to find the biggest number.*/
                end   /*#*/
                                                 /*stick a fork in it,  we're all done. */
say 'the biggest value in an array of '      #-1       " elements is: "           big
