/*REXX program finds all the  caseless  "odd words"  (within an identified dictionary). */
parse arg minL iFID .                            /*obtain optional arguments from the CL*/
if minL=='' | minL=="," then minL= 5             /*Not specified?  Then use the default.*/
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */
@.=                                              /*default value of any dictionary word.*/
           do #=1  while lines(iFID)\==0         /*read each word in the file  (word=X).*/
           x= strip( linein( iFID) )             /*pick off a word from the input line. */
           $.#= x;       upper x;       @.x= .   /*save: original case and the semaphore*/
           end   /*#*/                           /* [↑]   semaphore name is uppercased. */
#= # - 1                                         /*adjust word count because of DO loop.*/
minW= minL * 2 - 1                               /*minimum width of a word to be usable.*/
say copies('─', 30)     #     "words in the dictionary file: "       iFID
say
finds= 0                                         /*count of the  "odd words"  found.    */
        do j=1  for #;         L= length($.j)    /*process all the words that were found*/
        if L<minW  then iterate                  /*Is word too short?   Then ignore it. */
        ow=                                      /*initialize the  "odd word".          */
                   do k=1  by 2  to  L           /*only use odd indexed letters in word.*/
                   ow= ow  ||  substr($.j, k, 1) /*construct the  "odd word".           */
                   end   /*k*/
        owU= ow;               upper owU         /*uppercase the odd word to be caseless*/
        if @.owU==''  then iterate               /*if not extant,  then skip this word. */
        finds= finds + 1                         /*bump the count of "odd words" found. */
        say right(left($.j, 20), 24) left(ow, 9) /*indent original word for readability.*/
        end        /*j*/
                                                 /*stick a fork in it,  we're all done. */
say copies('─', 30)      finds     ' "odd words" found with a minimum length of '    minL
