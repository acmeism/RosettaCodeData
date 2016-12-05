/*REXX program finds all  even  numbers from an array, and marks the  not even  numbers.*/
parse arg N seed .                               /*obtain optional arguments from the CL*/
if N=='' | N==","      then N=50                 /*Not specified?  Then use the default.*/
if datatype(seed,'W')  then call random ,,seed   /*use the RANDOM seed for repeatability*/

               do i=1  for N                     /*generate N random numbers  ──►  OLD  */
               @.i=random(1,99999)               /*generate a random number 1 ──► 99999 */
               end   /*i*/

      do j=1  for N                              /*process the  OLD  array elements.    */
      if @.j//2 \==0  then @.j=                  /*mark the  @  array that it's not even*/
      end   /*j*/

      do k=1  for N                              /*display all the   @   even  numbers. */
      if @.k==''  then iterate                   /*if it's marked not even, then skip it*/
      say right('array.'k, 20) "=" right(@.k,9)  /*display a line  (an array element).  */
      end   /*k*/                                /*stick a fork in it,  we're all done. */
