/*REXX program finds all the  caseless words  (within an identified dictionary)  that   */
/*──────────────────────────────────────── either have odd letters that are vowels, and */
/*──────────────────────────────────────── even letters that consonants,  or vice versa.*/
parse arg minL iFID .                            /*obtain optional arguments from the CL*/
if minL=='' | minL=="," then minL= 10            /*Not specified?  Then use the default.*/
if iFID=='' | iFID=="," then iFID='unixdict.txt' /* "      "         "   "   "     "    */

              do #=1  while lines(iFID)\==0      /*read each word in the file  (word=X).*/
              x= strip( linein( iFID) )          /*pick off a word from the input line. */
              $.#= x                             /*save: original case and the semaphore*/
              end   /*#*/                        /* [↑]   semaphore name is uppercased. */
#= # - 1                                         /*adjust the record count  (DO loop).  */
say copies('─', 30)     #     "words in the dictionary file: "       iFID;       say
finds= 0                                         /*count of the words found  (so far).  */
vow= 'aeiou';     con= "bcdfghjklmnpqrstvwxyz"   /*list of vowels;  list of consonants. */
@@@=;             upper vow con                  /*@@@:  list of words found  (so far). */
w= 0                                             /*the maximum length of any word found.*/
    do j=1  for #;           L= length($.j)      /*process all the words that were found*/
    if L<minL  then iterate                      /*Is word too short?   Then ignore it. */
    y= $.j;    upper y                           /*obtain a word; and also uppercase it.*/
    ovec= 1;   ocev= 1                           /*for now, set both test cases: passed.*/
                                                 /*only scan odd indexed letters in word*/
      do ov=1  by 2  to  L;  z= substr(y, ov, 1) /*examine the odd letters in the word. */
      if verify(z, vow)>0  then ovec= 0          /*Odd letter not a vowel?  Then flunk. */
      end   /*k*/
                                                 /*only scan eve indexed letters in word*/
      do ev=2  by 2  to  L;  z= substr(y, ev, 1) /*examine the odd letters in the word. */
      if verify(z, con)>0  then ovec= 0          /*Even letter not a consonant?  Flunk. */
      end   /*k*/
                                                 /*only scan odd indexed letters in word*/
      do oc=1  by 2  to  L;  z= substr(y, oc, 1) /*examine the odd letters in the word. */
      if verify(z, con)>0  then ocev= 0          /*Odd letter not a consonant?   Flunk. */
      end   /*k*/
                                                 /*only scan eve indexed letters in word*/
      do ec=2  by 2  to  L;  z= substr(y, ec, 1) /*examine the odd letters in the word. */
      if verify(z, vow)>0  then ocev= 0          /*Even letter not a vowel?  Then flunk.*/
      end   /*k*/

    if ovec==0  &  ocev==0  then iterate         /*Did the word pass any test?  No, skip*/
    finds= finds + 1                             /*bump the count of "odd words" found. */
    w= max(w, L)                                 /*obtain the maximum length word found.*/
    @@@= @@@  $.j                                /*add a word to the list of words found*/
    end      /*j*/
                                                 /*stick a fork in it,  we're all done. */
say copies('─', 30)  finds     " words found with a minimum length of "      minL
_=
    do out=1  for finds;     z= word(@@@, out)   /*build a list that will be displayed. */
    if length(_ right(z, w))>130  then do;  say substr(_, 2);  _=;  end   /*show a line.*/
    _= _  right(z, w)                            /*append (aligned word) to output line.*/
    end   /*out*/
                                                 /*stick a fork in it,  we're all done. */
if _\==''  then say substr(_, 2)                 /*Any residual words?  Then show a line*/
