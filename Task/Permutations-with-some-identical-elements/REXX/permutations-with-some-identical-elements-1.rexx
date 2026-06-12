/*REXX program  computes and displays  the  permutations  with some identical elements. */
parse arg g                                      /*obtain optional arguments from the CL*/
if g='' | g=","  then g= 2 3 1                   /*Not specified?  Then use the defaults*/
#= words(g)                                      /*obtain the number of source items.   */
@= left('ABCDEFGHIJKLMNOPQRSTUVWXYZ',  #)        /*@:   the (output) letters to be used.*/
LO=                                              /*LO:  the start of the sequence.      */
HI=                                              /*HI:   "   end   "  "      "          */
      do i=1  for #;      @.i= word(g, i)        /*get number of characters for an arg. */
      LO= LO || copies(i, @.i)                   /*build the  LO  number for the range. */
      HI=       copies(i, @.i) || HI             /*  "    "   HI     "    "   "    "    */
      end   /*i*/
$=                                               /*initialize the output string to null.*/
      do j=LO  to  HI                            /*generate the enumerated output string*/
      if verify(j, LO)\==0  then iterate         /*An invalid digital string?  Then skip*/
         do k=1  for #                           /*parse string for correct # of digits.*/
         if countstr(k, j)\==@.k  then iterate j /*Incorrect number of digits?  Skip.   */
         end   /*k*/
      $= $ j                                     /*append digital string to the list.   */
      end      /*j*/
                                                 /*stick a fork in it,  we're all done. */
say 'number of permutations: '    words($)
say
say strip(translate($, @, left(123456789, #) ) ) /*display the translated string to term*/
