/*REXX pgm finds words  (within an identified dict.)  which contain the most consonants.*/
parse arg minl iFID .                            /*obtain optional arguments from the CL*/
if minl=='' | minl=="," then minl= 11            /*Not specified?  Then use the default.*/
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */

           do #=1  while lines(iFID)\==0         /*read each word in the file  (word=X).*/
           x= strip( linein( iFID) )             /*pick off a word from the input line. */
           @.#= x                                /*save:  the original case of the word.*/
           end   /*#*/
#= # - 1                                         /*adjust word count because of DO loop.*/
say copies('─', 30)      #       "words in the dictionary file: "       iFID
xyz= 'bcdfghjklmnpqrstvwxyz';        upper xyz   /*list of the 21 uppercase consonants. */
L= length(xyz)                                   /*number of consonants in the alphabet.*/
maxCnt= 0                                        /*max # unique consonants in a max set.*/
!.=;                                 !!.= 0      /* "  "    "        "      " " word.   */
      do j=1  for #;     $= @.j;     upper $     /*obtain an uppercased word from dict. */
      if length($)<minl         then iterate     /*Is word long enough?   No, then skip.*/
      cnt= 0                                     /*the number of consonants  (so far).  */

         do k=1  for L;  q= substr(xyz, K, 1)    /*examine all consonants for uniqueness*/
         _= pos(q, $)
         if _==0                then iterate     /*Is this consonant present?  No, skip.*/
         if pos(q, $, _ + 1)>0  then iterate j   /*More than 1 same consonant? Then skip*/
         cnt= cnt + 1                            /*bump the number of consonants so far.*/
         end      /*k*/

      !.cnt= !.cnt  @.j                          /*append a word to a specific len list.*/
      !!.cnt= cnt                                /*keep track of # of unique consonants.*/
      maxCnt= max(maxCNT, cnt)                   /*save the maximum count  (so far).    */
      end         /*j*/
                                                 /*show sets of words, unique consonants*/
      do m=maxCnt  to 1  by -1;  n= words(!.m)   /*get the number of words in this set. */
      if n==0  then iterate                      /*Any word in this set?  No, then skip.*/
                                 say;  say       /*show some blank lines between sets.  */
         do y=1  for n                           /*show individual words in the set.    */
         say right(y, L#)':'     right( left( word(!.m, y), 30),  40)    /*indent words.*/
         end   /*y*/

      say copies('─', 30)    n    " word"s(n)   'found which have '   !!.m   " unique" ,
                                  "consonants and having a minimum word length of: "  minl
      end   /*m*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
s:   if arg(1)==1  then return arg(3);   return word( arg(2) 's',  1)
