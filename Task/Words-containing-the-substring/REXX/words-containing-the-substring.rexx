/*REXX program finds words that contain the substring "the" (within an identified dict.)*/
parse arg $ minL iFID .                          /*obtain optional arguments from the CL*/
if    $=='' |    $=="," then    $= 'the'         /*Not specified?  Then use the default.*/
if minL=='' | minL=="," then minL= 12            /* "      "         "   "   "     "    */
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */
tell= minL>0;                minL= abs(minL)     /*use absolute value of minimum length.*/
@.=                                              /*default value of any dictionary word.*/
            do #=1  while lines(iFID)\==0        /*read each word in the file  (word=X).*/
            @.#= strip( linein( iFID) )          /*pick off a word from the input line. */
            end   /*#*/
#= # - 1                                         /*adjust word count because of DO loop.*/
$u= $;                                  upper $u /*obtain an uppercase version of  $.   */
say copies('─', 25)     #     "words in the dictionary file: "       iFID
say
finds= 0                                         /*count of the substring found in dict.*/
         do j=1  for #;     z= @.j;     upper z  /*process all the words that were found*/
         if length(z)<minL  then iterate         /*Is word too short?    Yes, then skip.*/
         if pos($u, z)==0   then iterate         /*Found the substring?   No,   "    "  */
         finds= finds + 1                        /*bump count of substring words found. */
         if tell  then say right(left(@.j, 20), 25)    /*Show it?  Indent original word.*/
         end        /*j*/
                                                 /*stick a fork in it,  we're all done. */
say copies('─', 25)     finds     " words (with a min. length of"  ,
                                  minL') that contains the substring: '     $
