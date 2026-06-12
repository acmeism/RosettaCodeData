/*REXX program finds all the caseless alternade words (within an identified dictionary).*/
parse arg minL iFID .                            /*obtain optional arguments from the CL*/
if minL=='' | minL=="," then minL= 6             /*Not specified?  Then use the default.*/
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */
@.=                                              /*default value of any dictionary word.*/
            do #=1  while lines(iFID)\==0        /*read each word in the file  (word=X).*/
            x= strip( linein( iFID) )            /*pick off a word from the input line. */
            $.#= x;       upper x;       @.x= .  /*save: original case and the semaphore*/
            end   /*#*/                          /* [↑]   semaphore name is uppercased. */
#= # - 1                                         /*adjust word count because of DO loop.*/
finds= 0                                         /*count of the alternade words found.  */
say copies('─', 30)      #      "words in the dictionary file: "       iFID
say
        do j=1  for #;           L= length($.j)  /*process all the words that were found*/
        if L<minL  then iterate                  /*Is word too short?   Then ignore it. */
        p.=                                      /*initialize 2 parts of alternade word.*/
             do k=1  for L;         _= k // 2    /*build the  "   "    "      "      "  */
             p._= p._  ||  substr($.j, k, 1)     /*append to one part of alternade word.*/
             end   /*k*/

        parse upper value  p.0 p.1  with  p0 p1  /*obtain the uppercase alternade parts.*/
        if @.p0=='' | @.p1==''  then iterate     /*either parts of alternade not extant?*/
        finds= finds + 1                         /*bump the  count  of alternades found.*/
        say right(left($.j, 20), 25)    left(p.1, 10)    left(p.0, 10)   /*indent a bit.*/
        end        /*j*/
                                                 /*stick a fork in it,  we're all done. */
say copies('─',30)    finds   '  alternade words found with a minimum length of '    minL
