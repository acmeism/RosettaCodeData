/*REXX pgm finds all words that contain only one vowel each (no duplication of vowels). */
parse arg minL iFID .                            /*obtain optional arguments from the CL*/
if minL=='' | minL=="," then minL= 11            /*Not specified?  Then use the default.*/
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */
@.=                                              /*default value of any dictionary word.*/
            do #=1  while lines(iFID)\==0        /*read each word in the file  (word=X).*/
            x= strip( linein( iFID) )            /*pick off a word from the input line. */
            $.#= x                               /*save: original case and the semaphore*/
            end   /*#*/                          /* [↑]   semaphore name is uppercased. */
#= # - 1                                         /*adjust word count because of DO loop.*/
finds= 0                                         /*count of the alternade words found.  */
say copies('─', 30)      #      "words in the dictionary file: "       iFID
vowels= 'aeiou';                upper vowels     /*create a list of vowels; uppercase it*/
say;                   Lv=  length(vowels)       /*obtain the number of vowels (faster).*/
        do j=1  for #;          L= length($.j)   /*process all the words that were found*/
        if L<minL  then iterate                  /*Is word too short?   Then ignore it. */
        y= $.j;                 upper y          /*uppercase the dictionary word.       */
        if verify(vowels, y)>0  then iterate     /*The word have a least each vowel ?   */     /* ◄──── optional test (for speed).*/
           do k=1  for Lv                        /*process each of the vowels specified.*/
           v= substr(vowels, k, 1)               /*extract a vowel from the vowel list. */
           _= pos(v, y)                          /*find the position of the first vowel.*/
           if pos(v, y, _+1)\==0  then iterate j /*Is there another  (of the same)  ··· */
           end   /*k*/                           /*   ··· vowel?     Yes, then skip it. */
        finds= finds + 1                         /*bump the  count  of alternades found.*/
        say right( left($.j, 25),  40)           /*indent the word for a better display.*/
        end        /*j*/
                                                 /*stick a fork in it,  we're all done. */
say copies('─',30)    finds   ' words found with only one each of every vowel,'   ,
                              " and with a minimum length of "    minL
