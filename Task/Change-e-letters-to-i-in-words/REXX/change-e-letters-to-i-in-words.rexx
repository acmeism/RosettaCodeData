/*REXX pgm finds words with changed letter  E──►I  and is a word  (in a specified dict).*/
parse arg minL oldC newC iFID .                  /*obtain optional arguments from the CL*/
if minL=='' | minL=="," then minL=  6            /*Not specified?  Then use the default.*/
if oldC=='' | oldC=="," then oldC= 'e'           /* "      "         "   "   "     "    */
if newC=='' | newC=="," then newC= 'i'           /* "      "         "   "   "     "    */
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */
upper oldC newC                                  /*get uppercase versions of OLDC & NEWC*/
@.=                                              /*default value of any dictionary word.*/
           do #=1  while lines(iFID)\==0         /*read each word in the file  (word=X).*/
           x= strip( linein( iFID) )             /*pick off a word from the input line. */
           $.#= x;       upper x;     @.x= $.#   /*save: original case and the old word.*/
           end   /*#*/                           /*Note: the old word case is left as─is*/
#= # - 1                                         /*adjust word count because of DO loop.*/
finds= 0                                         /*count of changed words found (so far)*/
say copies('─', 30)      #      "words in the dictionary file: "       iFID
say
       do j=1  for #;           L= length($.j)   /*process all the words that were found*/
       if L<minL  then iterate                   /*Is word too short?   Then ignore it. */
       y = $.j;                 upper y          /*uppercase the dictionary word.       */
       if pos(oldC, y)==0  then iterate          /*Have the required character? No, skip*/
       new= translate(y, newC, oldC)             /*obtain a changed (translated) word.  */
       if @.new==''  then iterate                /*New word in the dict.?   No, skip it.*/
       finds= finds + 1                          /*bump the count of found changed words*/
       say right(left($.j, 20), 40) '──►' @.new  /*indent a bit, display the old & new. */
       end        /*j*/
say                                              /*stick a fork in it,  we're all done. */
say copies('─',30)    finds    " words found that were changed with "    oldC    '──►' ,
                      newC",  and with a minimum length of "     minL
