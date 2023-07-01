/*REXX program displays the sequence (and/or lengths) for the    look and say    series.*/
parse arg N ! .                                  /*obtain optional arguments from the CL*/
if N=='' | N==","  then N= 20                    /*Not specified?  Then use the default.*/
if !=='' | !==","  then !=  1                    /* "      "         "   "   "     "    */
                                                 /* [↑]  !:   starting char for the seq.*/
     do j=1  for abs(N)                          /*repeat a number of times to show NUMS*/
     if j\==1  then != lookNsay(!)               /*invoke function to calculate next #. */
     if N<0    then say 'length['j"]:" length(!) /*Also,  display the sequence's length.*/
               else say '['j"]:"      !          /*display the number to the terminal.  */
     end   /*j*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
lookNsay: procedure; parse arg x,,$ !            /*obtain the (passed) argument  {X}.   */
          chSize= 1000                           /*define a sensible chunk size.        */
          fin = '0'x                             /*use unique character to end scanning.*/
          x= x || fin                            /*append the  FIN  character to string.*/
               do k=1  by 0                      /*now,  process the given sequence.    */
                  y=  substr(x, k, 1)            /*pick off one character to examine.   */
               if y==fin  then return $          /*if we're at the end, then we're done.*/
               _= verify(x, y, , k)  - k         /*see how many characters we have of Y.*/
               $= $  ||  _  ||  y                /*build the  "look and say"  sequence. */
               k= k + _                          /*now, point to the next character.    */
               if length($)<chSize  then iterate /*Less than chunkSize?  Then keep going*/
               != !  ||  $                       /*append   $   to the  !  string.      */
               $=                                /*now,  start   $   from scratch.      */
               chSize= chSize + 100              /*bump the  chunkSize (length) counter.*/
               end   /*k*/
         return ! || $                           /*return the ! string plus the $ string*/
