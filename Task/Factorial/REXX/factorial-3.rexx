/*REXX program computes the factorial of a number, striping trailing 0's*/
numeric digits 200                     /*start with two hundred digits. */
parse arg N .;     if N==''  then N=0  /*get argument from command line.*/
!=1                                    /*define factorial produce so far*/
/*═══════════════════════════════════════where the rubber meets the road*/
   do j=2  to N                        /*compute factorial the hard way.*/
   old!=!                              /*save old ! in case of overflow.*/
   !=!*j                               /*multiple old factorial with  J.*/
   if pos('E',!)\==0 then do           /*is  !  in exponential notation?*/
                          d=digits()   /*D   temporarly stores # digits.*/
                          numeric digits d+d%10     /*add 10% do digits.*/
                          !=old!*j     /*recalculate for the lost digits*/
                          end          /*IFF ≡ if and only if.  [↓]     */
   if right(!,1)==0 then !=strip(!,,0) /*strip trailing zeroes  IFF  the*/
   end   /*j*/                         /* [↑]  right-most digit is zero.*/
z=0                                    /*the number of trailing zeroes. */
   do v=5  by 0  while v<=N            /*calculate # of trailing zeroes.*/
   z=z+N%v                             /*bump Z if multiple power of 5. */
   v=v*5                               /*calculate the next power of 5. */
   end   /*while v≤N*/                 /* [↑]  advance  V  by ourselves.*/
/*══════════════════════════════════════════════════════════════════════*/
!=! || copies(0,z)                     /*add water to rehydrate the  !. */
if z==0  then z='no'                   /*use gooder English for message.*/
say N'!  is      ['length(!) " digits  with "    z    ' trailing zeroes]:'
say                                    /*display blank line (whitespace)*/
say !                                  /* ··· and display the ! product.*/
                                       /*stick a fork in it, we're done.*/
