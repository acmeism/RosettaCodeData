/*REXX program simulates reading a ten─line file,  count selection randomness.*/
N=10                                   /*the number of lines in pseudo-file.  */
@.=0                                   /*zero  all  the (ten)  "buckets".     */
      do 1000000                       /*perform main loop  one million times.*/
      ?=1
                 do k=1  for N         /*N  is the number of lines in the file*/
                 if random(0,99999) / 100000  <  1/k  then ?=k  /*the criteria*/
                 end   /*k*/
      @.?=@.?+1                        /*bump the count in a particular bucket*/
      end              /*1000000*/

   do j=1  for N                       /*display randomness counts (buckets). */
   say "number of times line"    right(j,2)    "was selected:"    right(@.j,9)
   end   /*j*/
                                       /*stick a fork in it,  we're all done. */
