/*REXX pgm finds words in an specified dict. which have the same 1st and last 3 letters.*/
parse arg minL many iFID .                       /*obtain optional arguments from the CL*/
if minL=='' | minL=="," then minL=  6            /* "      "         "   "   "     "    */
if many=='' | many=="," then many=  3            /* "      "         "   "   "     "    */
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */

              do #=1  while lines(iFID)\==0      /*read each word in the file  (word=X).*/
              x= strip( linein( iFID) )          /*pick off a word from the input line. */
              @.#= x                             /*save:  the original case of the word.*/
              end   /*#*/
#= # - 1                                         /*adjust word count because of DO loop.*/
say copies('─', 30)     #     "words in the dictionary file: "       iFID
finds= 0                                         /*word count which have matching end.  */
                                                 /*process all the words that were found*/
     do j=1  for #;          $= @.j;    upper $  /*obtain dictionary word; uppercase it.*/
     if length($)<minL  then iterate             /*Word not long enough?   Then skip it.*/
     lhs= left($, many);     rhs= right($, many) /*obtain the left & right side of word.*/
     if \datatype(lhs || rhs, 'U')  then iterate /*are the left and right side letters? */
     if lhs \== rhs                 then iterate /*Left side match right side?  No, skip*/
     finds= finds + 1                            /*bump count of only "e" vowels found. */
     say right( left(@.j, 30),  40)              /*indent original word for readability.*/
     end        /*j*/
                                                 /*stick a fork in it,  we're all done. */
say copies('─', 30)  finds  " words found that the left "   many   ' letters match the' ,
                            "right letters which a word has a minimal length of "     minL
