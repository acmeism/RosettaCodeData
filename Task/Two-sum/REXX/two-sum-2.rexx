/*REXX program finds two numbers in a list of numbers that  sum  to a particular target.*/
numeric digits 500                               /*be able to handle some larger numbers*/
parse arg targ list                              /*obtain optional arguments from the CL*/
if targ='' | targ=","  then targ= 21             /*Not specified?  Then use the defaults*/
if list='' | list=","  then list= 0 2 11 19 90   /* "      "         "   "   "     "    */
say 'the list:       '   list                    /*echo the     list     to the terminal*/
say 'the target sum: '   targ                    /*  "   "   target sum   "  "     "    */
w= 0;                    sol= 0                  /*width;  # of solutions found (so far)*/
      do #=0  for words(list); _=word(list, #+1) /*examine the list, construct an array.*/
      @.#= _;            w= max(w, length(_) )   /*assign a number to an indexed array. */
      end  /*#*/                                 /*W:  the maximum width of any number. */
L= length(#)                                     /*L:   "     "      "    "  "  index.  */
@solution= 'a solution:  zero─based indices   '  /*a SAY literal for space conservation.*/
say                                              /* [↓] look for sum of 2 numbers=target*/
      do    a=0    for #                         /*scan up to the last number in array. */
         do b=a+1  to  #-1;  if @.a + @.b\=targ  then iterate   /*Sum not correct? Skip.*/
         sol= sol + 1                            /*bump count of the number of solutions*/
         say @solution       center( "["right(a, L)','       right(b, L)"]",     L+L+5) ,
             right(@.a, w*4)     " + "       right(@.b, w)       ' = '           targ
         end   /*b*/                             /*show the 2 indices and the summation.*/
      end      /*a*/
say
if sol==0  then sol= 'None'                      /*prettify the number of solutions if 0*/
say 'number of solutions found: '   sol          /*stick a fork in it,  we're all done. */
