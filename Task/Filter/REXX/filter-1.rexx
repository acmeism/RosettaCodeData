/*REXX program selects all  even numbers  from an array and puts them  ──►  a new array.*/
parse arg N seed .                               /*obtain optional arguments from the CL*/
if N=='' | N==","      then N=50                 /*Not specified?  Then use the default.*/
if datatype(seed,'W')  then call random ,,seed   /*use the RANDOM seed for repeatability*/
old.=                                            /*the OLD array,  all are null so far. */
new.=                                            /* "  NEW    "     "   "    "   "  "   */
               do i=1  for N                     /*generate  N  random numbers ──►  OLD */
               old.i=random(1,99999)             /*generate random number   1  ──► 99999*/
               end   /*i*/
#=0                                              /*number of elements in  NEW  (so far).*/
      do j=1  for N                              /*process the elements of the OLD array*/
      if old.j//2 \== 0  then iterate            /*if element isn't even,  then skip it.*/
      #=#+1                                      /*bump the number of  NEW  elements.   */
      new.#=old.j                                /*assign the number to the  NEW  array.*/
      end   /*j*/

      do k=1  for #                              /*display all the  NEW   numbers.      */
      say right('new.'k, 20) "=" right(new.k,9)  /*display a line  (an array element).  */
      end   /*k*/                                /*stick a fork in it,  we're all done. */
