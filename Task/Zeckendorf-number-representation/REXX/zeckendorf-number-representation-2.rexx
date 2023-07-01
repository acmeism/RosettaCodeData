/*REXX program  calculates and displays the  first   N   Zeckendorf numbers.            */
numeric digits 100000                            /*just in case user gets real ka─razy. */
parse arg N .                                    /*let the user specify the upper limit.*/
if N=='' | N==","  then n=20;   w= length(N)     /*Not specified?  Then use the default.*/
@.1= 1                                           /*start the array with  1   and   2.   */
@.2= 2;   do  #=3  until #>=N;  p= #-1;  pp= #-2 /*build a list of Fibonacci numbers.   */
          @.#= @.p + @.pp                        /*sum the last two Fibonacci numbers.  */
          end   /*#*/                            /* [↑]   #:  contains a Fibonacci list.*/

  do j=0  to N;             parse var j x z      /*task:  process zero  ──►  N  numbers.*/
     do k=#  by -1  for #;  _= @.k               /*process all the Fibonacci numbers.   */
     if x>=_  then do;      z= z'1'              /*is X>the next Fibonacci #?  Append 1.*/
                            x= x - _             /*subtract this Fibonacci # from index.*/
                   end
              else z= z'0'                       /*append zero (0)  to the Fibonacci #. */
     end   /*k*/
  say '    Zeckendorf'     right(j, w)    "="     right(z+0, 30)     /*display a number.*/
  end     /*j*/                                  /*stick a fork in it,  we're all done. */
