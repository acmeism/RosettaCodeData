/*REXX program illustrates building a simple inverted index & word find.*/
@.=''                                  /*dictionary of words   (so far).*/
!=''                                   /*a list of found words (so far).*/
call invertI 0, 'BURMA0.TXT'           /*read the file:  BURMA0.TXT  ...*/
call invertI 1, 'BURMA1.TXT'           /*  "   "    ~    BURMA1.TXT  ...*/
call invertI 2, 'BURMA2.TXT'           /*  "   "    ~    BURMA2.TXT  ...*/
call invertI 3, 'BURMA3.TXT'           /*  "   "    ~    BURMA3.TXT  ...*/
call invertI 4, 'BURMA4.TXT'           /*  "   "    ~    BURMA4.TXT  ...*/
call invertI 5, 'BURMA5.TXT'           /*  "   "    ~    BURMA5.TXT  ...*/
call invertI 6, 'BURMA6.TXT'           /*  "   "    ~    BURMA6.TXT  ...*/
call invertI 7, 'BURMA7.TXT'           /*  "   "    ~    BURMA7.TXT  ...*/
call invertI 8, 'BURMA8.TXT'           /*  "   "    ~    BURMA8.TXT  ...*/
call invertI 9, 'BURMA9.TXT'           /*  "   "    ~    BURMA9.TXT  ...*/
call findAword 'does'                  /*find a word.                   */
call findAword '60'                    /*find another word.             */
call findAword "don't"                 /*and find another word.         */
call findAword "burma-shave"           /*and find yet another word.     */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FINDAWORD subroutine────────────────*/
findAword:  procedure expose @.; arg x /*get an uppercase version of X. */
parse arg ox                           /*get original (as-is) value of X*/
_=@.x;    oxo='───'ox"───"
if _==''  then do
               say 'word'   oxo   "not found."
               return 0
               end
_@=_                                   /*save _, pass it back to invoker*/
say 'word'  oxo  "found in:"
                             do  until _=='';      parse var   _   f  w  _
                             say '       file='f '  word='w
                             end   /*until ··· */
return _@
/*─────────────────────────────────────INVERTI subroutine───────────────*/
invertI:  procedure expose @. !;  parse arg #,fn       /*file#, filename*/
call lineout fn                        /*close the file, just in case.  */
w=0                                    /*number of words found (so far).*/
    do  while lines(fn)\==0            /* [↓]   process the entire file.*/
    _=space(linein(fn))                /*read a line, elide extra blanks*/
    if _==''  then iterate             /*if blank record, then ignore it*/
    say 'file' #", record:" _          /*echo a record  (to be verbose).*/

      do  until _==''                  /*pick off words until done.     */
      parse upper var   _   ?  _       /*pick off a word (uppercased).  */
      ?=stripper(?)                    /*strip any trailing punctuation.*/
      if ?=''  then iterate            /*is the word now blank (null) ? */
      w=w+1                            /*bump the word counter (index). */
      @.?=@.? # w                      /*append the new word to a list. */
      if wordpos(?,!)==0  then !=! ?   /*add to the list of words found.*/
      end   /*until ··· */
    end     /*while ··· */
say;        call lineout fn            /*close the file, just to be neat*/
return w                               /*return the index of the word.  */
/*─────────────────────────────────────STRIPPER subroutine──────────────*/
stripper:  procedure;  parse arg q     /*remove punctuation at word-end.*/
@punctuation='.,:;?¿!¡∙·';   do j=1  for length(@punctuation)
                             q=strip(q,'T',substr(@punctuation,j,1))
                             end   /*j*/
return q
