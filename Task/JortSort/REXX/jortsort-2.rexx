/*REXX program  verifies  that  an array  is sorted  using  a   jortSort   algorithm.   */
parse arg $                                      /*obtain the list of numbers from C.L. */
if $=''  then $=1 2 4 3                          /*Not specified?  Then use the default.*/
say 'array items='  space($)                     /*display the list to the terminal.    */
if jortSort($)  then say  'The array is sorted.'
                else say  "The array isn't sorted."
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
jortSort: parse arg x
          p=word(x,1)
                       do j=2  to words(x);  _=word(x,j)
                       if _<p  then return 0                      /*array  isn't sorted.*/
                       p=_
                       end   /*j*/
          return 1                                                /*array  is    sorted.*/
