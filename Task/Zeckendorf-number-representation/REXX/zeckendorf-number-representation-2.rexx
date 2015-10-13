/*REXX program calculates and displays the first   N   Zeckendorf numbers.    */
numeric digits 100000                  /*just in case user gets real ka─razy. */
parse arg N .;    if N==''  then n=20  /*let user specify the upper limit.    */
#=1 2;    do  until  w>N               /*build a list of Fibonacci numbers.   */
          w=words(#)                   /*number of words in list of Fibonacci#*/
          #=# (word(#,w-1) +word(#,w)) /*add the last two Fibonacci numbers.  */
          end   /*until*/              /* [↑]   #:  contains a Fibonacci list.*/

  do j=0  to N;    parse var j x z     /*task:  process zero  ──►  N  numbers.*/
    do k=w  by -1  for w;  _=word(#,k) /*process all the Fibonacci numbers.   */
    if x>=_  then do;      z=z'1'      /*is X>the next Fibonacci #?  Append 1.*/
                           x=x-_       /*subtract this Fibonacci # from index.*/
                  end
             else z=z'0'               /* append zero (0)  to the Fibonacci #.*/
    end   /*k*/
  say '    Zeckendorf'  right(j,length(N))  '= '  right(z+0,30)      /*show #.*/
  end     /*j*/
                                       /*stick a fork in it,  we're all done. */
