/*REXX pgm to calculate and display the first   N   Zeckendorf  numbers.*/
numeric digits 1000                    /*just in case user gets ka-razy.*/
parse arg n .;   if n=='' then n=20    /*let user specify upper limit.  */
#=1 2;     do until word(#,words(#))>n /*build a list of Fib numbers.   */
           w=words(#)                  /*number of words in list of Fib#*/
           #=# (word(#,w-1)+word(#,w)) /*sum the last two Fib numbers.  */
           end   /*until word(#, ... */

    do j=0  to n;   parse var j x z    /*task: process zero  ──►   N.   */
      do k=w by -1 for w;  _=word(#,k) /*process all the Fib numbers.   */
      if x>=_  then do                 /*is X>than the next Fib number? */
                    z=z'1'             /* ... then append unity  (1).   */
                    x=x-_              /*subtract this fib# from index. */
                    end
               else z=z'0'             /* append zero (0).              */
      end   /*k*/
    say '    Zeckendorf' right(j,length(n)) '= ' right(0+z,30)  /*show #*/
    end     /*j*/
                                       /*stick a fork in it, we're done.*/
