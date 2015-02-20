/*REXX program calculates and displays the first  N  Zeckendorf numbers.*/
numeric digits 1000                    /*just in case user gets ka-razy.*/
parse arg N .;    if N==''  then n=20  /*let user specify upper limit.  */
#=1 2;    do  until  w>N               /*build a list of Fib numbers.   */
          w=words(#)                   /*number of words in list of Fib#*/
          #=# (word(#,w-1) +word(#,w)) /*add the last two Fib numbers.  */
          end   /*until*/              /* [↑]   #:  contains a Fib list.*/

  do j=0  to N;    parse var j x z     /*task:  process zero  ──►   N   */
    do k=w  by -1  for w;  _=word(#,k) /*process all the Fibonacci nums.*/
    if x>=_  then do                   /*is  X  >  the next Fib number? */
                  z=z'1'               /* ··· then append unity  (1).   */
                  x=x-_                /*subtract this fib# from index. */
                  end
             else z=z'0'               /* append zero (0) to the number.*/
    end   /*k*/
  say '    Zeckendorf' right(j,length(N)) '= ' right(z+0,30)   /*show #.*/
  end     /*j*/
                                       /*stick a fork in it, we're done.*/
