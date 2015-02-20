/*REXX program to display (a range of) ludic numbers, or a count of same*/
parse arg N count bot top triples .    /*obtain optional parameters/args*/
if N==''        then N=25              /*Not specified? Use the default.*/
if count==''    then count=1000        /* "      "       "   "     "    */
if bot==''      then bot=2000          /* "      "       "   "     "    */
if top==''      then top=2005          /* "      "       "   "     "    */
if triples==''  then triples=250-1     /* "      "       "   "     "    */
say 'The first '   N   " ludic numbers: "   ludic(n)
say
say "There are " words(ludic(-count)) ' ludic numbers from 1───►'count " (inclusive)."
say
say "The "  bot   ' to '   top    " ludic numbers are: "    ludic(bot,top)
$=ludic(-triples) 0 0;     #=0;   @=
say
     do j=1  for words($); _=word($,j) /*it is known that ludic _ exists*/
     if wordpos(_+2,$)==0 | wordpos(_+6,$)==0  then iterate   /*¬triple.*/
     #=#+1;    @=@ '◄'_  _+2  _+6"► "  /*bump triple counter,  and ···  */
     end   /*j*/                       /* [↑]  append found triple ──► @*/

if @==''  then  say  'From 1──►'triples", no triples found."
          else  say  'From 1──►'triples", "   #   ' triples found:'   @
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────LUDIC subroutine────────────────────*/
ludic: procedure; parse arg m 1 mm,h;  am=abs(m);     if h\==''  then am=h
$=1 2;    @=                           /*$=ludic #s superset, @=# series*/
                                       /* [↓]  construct a ludic series.*/
  do j=3  by 2  to am * max(1,15*((m>0)|h\==''));  @=@ j;  end;     @=@' '
                                       /* [↑]  high limit: approx|exact */
  do  while  words(@)\==0              /* [↓]  examine the first word.  */
  f=word(@,1);       $=$ f             /*append this first word to list.*/
       do d=1  by f  while d<=words(@) /*use 1st #, elide all occurances*/
       @=changestr(' 'word(@,d)" ",@, ' . ')  /*delete the # in the seq#*/
       end   /*d*/                     /* [↑]  done eliding "1st" number*/
  @=translate(@,,.)                    /*translate periods to blanks.   */
  end         /*forever*/              /* [↑]  done eliding ludic #s.   */
@=space(@)                             /*remove extra blanks from list. */

if h==''  then return subword($,1,am)  /*return a range of ludic numbers*/
               return subword($,m,h-m+1)  /*return a section of a range.*/
