/*REXX program displays (a range of)  ludic numbers, or a count of when a range is used.*/
parse arg N count bot top triples .              /*obtain optional arguments from the CL*/
if       N=='' |       N=="," then       N=25    /*Not specified?  Then use the default.*/
if   count=='' |   count=="," then   count=1000  /* "      "         "   "   "     "    */
if     bot=='' |     bot=="," then     bot=2000  /* "      "         "   "   "     "    */
if     top=='' |     top=="," then     top=2005  /* "      "         "   "   "     "    */
if triples=='' | triples=="," then triples=250-1 /* "      "         "   "   "     "    */
say 'The first '  N  " ludic numbers: " ludic(n) /*display title for what's coming next.*/
say
say "There are "  words(ludic(-count))   ' ludic numbers from 1───►'count "  (inclusive)."
say
say "The "  bot   ' to '   top    " ludic numbers are: "    ludic(bot,top)
$=ludic(-triples) 0 0;     #=0;   @=
say
     do j=1  for words($);          _=word($,j)  /*it is known that ludic   _   exists. */
     if wordpos(_+2, $)==0  |  wordpos(_+6, $)==0  then iterate  /*Not triple?  Skip it.*/
     #=#+1;    @=@ '◄'_  _+2  _+6"► "            /*bump the triple counter,  and  ···   */
     end   /*j*/                                 /* [↑]  append the found triple ──►  @ */

if @==''  then  say  'From 1──►'triples", no triples found."
          else  say  'From 1──►'triples", "     #     ' triples found:'      @
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
ludic: procedure; parse arg m,h; am=abs(m); if h\==''  then am=h; $=1 2;  yes=m>0 | h\==''
@=                                               /*$≡ludic numbers superset;  @≡sequence*/
            do j=3  by 2  to  am*max(1, 15*yes)  /*construct an initial list of numbers.*/
            @=@ j                                /* [↓]  construct a  ludic  sequence.  */
            end   /*j*/                          /* [↑]  high limit:  approx or exact.  */
@=@' '                                           /*append a blank to the number sequence*/
            do  while words(@)\==0; f=word(@,1)  /* [↓]  examine the first word.        */
            $=$ f                                /*append this first word to the list.  */
                 do d=1  by f  while d<=words(@) /*use 1st number, elide all occurrences*/
                 y=word(@,d)                     /*obtain the  Yth  word  of  @  string.*/
                 @=changestr(' 'y" ", @, ' . ')  /*delete the number in the sequence.   */
                 end   /*d*/                     /* [↑]  done eliding the "1st" number. */
            @=translate(@, , .)                  /*translate periods (dots)  to blanks. */
            end        /*while*/                 /* [↑]  done eliding ludic numbers.    */

if h==''  then return subword($,  1, am)         /*return a  range  of  ludic  numbers. */
               return subword($, am, h-m+1)      /*return a section of a range.         */
