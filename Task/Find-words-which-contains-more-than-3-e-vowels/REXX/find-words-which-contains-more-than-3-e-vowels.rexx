/*REXX pgm finds words (within an identified dict.)  which contain more than three "e"s.*/
parse arg char many iFID .                       /*obtain optional arguments from the CL*/
if char=='' | char=="," then char= 'e'           /*Not specified?  Then use the default.*/
if many=='' | many=="," then many=  4            /* "      "         "   "   "     "    */
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */
chrU= char;                  upper chrU          /*obtain an uppercase version of  char.*/
           do #=1  while lines(iFID)\==0         /*read each word in the file  (word=X).*/
           x= strip( linein( iFID) )             /*pick off a word from the input line. */
           @.#= x                                /*save:  the original case of the word.*/
           end   /*#*/
#= # - 1                                         /*adjust word count because of DO loop.*/
say copies('─', 30)     #        "words in the dictionary file: "       iFID
finds= 0                                         /*count of the  "eeee"  words found.   */
vowels= 'aeiou'                                  /*obtain the list of all the vowels.   */
upper vowels                                     /*uppercase all the other vowels.      */
vowels= space( translate(vowels, , chrU),  0)    /*elide the one vowel we're looking for*/
                                                 /*process all the words that were found*/
     do j=1  for #;    $= @.j;         upper $   /*obtain word from dict.; uppercase it.*/
     if verify(vowels, $, 'M')>0  then iterate   /*Does it contain other vowels? Skip it*/
     if countstr(chrU, $) < many  then iterate   /*  "   " have enough of  'e's?   "   "*/
     finds= finds + 1                            /*bump count of only "e" vowels found. */
     say right( left(@.j, 30),  40)              /*indent original word for readability.*/
     end        /*j*/
                                                 /*stick a fork in it,  we're all done. */
say copies('─', 30) finds  " words found having "  many ' ' copies(char, many) " letters."
