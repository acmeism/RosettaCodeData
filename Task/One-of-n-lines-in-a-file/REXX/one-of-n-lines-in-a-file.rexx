/*REXX pgm simulates reading a ten-line file and make randomness counts.*/
N=10                                   /*number of lines in pseudo-file.*/
#.=0                                   /*zero  all  the (ten)  buckets. */
      do 1000000                       /*perform one million trials.    */
      ?=1
                 do k=1  for N         /*N is the # of lines in the file*/
                 if random(0,99999)/100000<1/k  then ?=k  /*the critera.*/
                 end   /*k*/
      #.?=#.?+1                        /*add it to the bucket counters. */
      end              /*1000000*/

   do j=1 for N                        /*display the randomness counts. */
   say "number of times line"  right(j,2)  "was selected:"  right(#.j,9)
   end   /*j*/
                                       /*stick a fork in it, we're done.*/
