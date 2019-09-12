/*REXX program simulates a 7─sided die based on a 5─sided throw for a number of trials. */
parse arg trials sample seed .                   /*obtain optional arguments from the CL*/
if trials=='' | trials=","  then trials=       1 /*Not specified?  Then use the default.*/
if sample=='' | sample=","  then sample= 1000000 /* "      "         "   "   "     "    */
if datatype(seed,'W')  then call random ,,seed   /*Integer?  Then use it as a RAND seed.*/
L= length(trials)                                /* [↑]  one million samples to be used.*/

   do #=1  for trials;          die.= 0          /*performs the number of desired trials*/
   k= 0
               do  until k==sample;             r= 5 * random(1, 5)  +  random(1, 5)  -  6
               if r>20  then iterate
               k= k+1;                          r=r // 7  +  1;         die.r= die.r + 1
               end   /*until*/
   say
   expect= sample % 7
   say center('trial:' right(#, L)    "   "     sample  'samples, expect' expect, 80, "─")

               do j=1  for 7
               say '      side'      j       "had "       die.j           ' occurrences',
                   '      difference from expected:'right(die.j - expect, length(sample) )
               end   /*j*/
   end   /*#*/                                   /*stick a fork in it,  we're all done. */
