/*REXX program illustrates building a simple inverted index & word find.*/
@.=''                                  /*dictionary of words   (so far).*/
!=''                                   /*a list of found words (so far).*/

call invertI 0, 'BURMA0.TXT'           /*read file 0 ...                */
call invertI 1, 'BURMA1.TXT'           /*  "   "   1 ...                */
call invertI 2, 'BURMA2.TXT'           /*  "   "   2 ...                */
call invertI 3, 'BURMA3.TXT'           /*  "   "   3 ...                */
call invertI 4, 'BURMA4.TXT'           /*  "   "   4 ...                */
call invertI 5, 'BURMA5.TXT'           /*  "   "   5 ...                */
call invertI 6, 'BURMA6.TXT'           /*  "   "   6 ...                */
call invertI 7, 'BURMA7.TXT'           /*  "   "   7 ...                */
call invertI 8, 'BURMA8.TXT'           /*  "   "   8 ...                */
call invertI 9, 'BURMA9.TXT'           /*  "   "   9 ...                */

call findAword 'does'                  /*find a word.                   */
call findAword '60'                    /*find another word.             */
call findAword "don't"                 /*and find another word.         */
call findAword "burma-shave"           /*and find yet another word.     */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────FINDAWORD subroutine────────────────*/
findAword:  procedure expose @.        /*get A word, and uppercase it.  */
parse arg ox;    arg x                 /*OX= word;  X= uppercase version*/
_=@.x
oxo='───'ox"───"
if _==''  then do
               say 'word' oxo "not found."
               return 0
               end
_@=_                                   /*save _, pass it back to invoker*/
say 'word' oxo "found in:"
                             do until _=='';       parse var _ f w _;  say
                             say '       file='f ' word='w
                             end   /*until ... */
return _@
/*─────────────────────────────────────INVERTI subroutine───────────────*/
invertI:  procedure expose @. !;  parse arg #,fn       /*file#, filename*/
call lineout fn                        /*close the file, just in case.  */
w=0                                    /*number of words so far.        */

  do  while lines(fn)\==0              /*process the entire file (below)*/
  _=space(linein(fn))                  /*read 1 line, elide extra blanks*/
  if _==''  then iterate               /*if blank record, then ignore it*/
  say 'file' #",record="_              /*echo a record, just to be verbose.*/

    do  until _==''                    /*pick off words until done.     */
    parse upper var _ xxx _            /*pick off a word (uppercased).  */
    xxx=stripper(xxx)                  /*strip any ending punctuation.  */
    if xxx='' then iterate             /*is the word now blank (null) ? */
    w=w+1                              /*bump the word counter.         */
    @.xxx=@.xxx # w
    if wordpos(xxx,!)==0 then !=! xxx  /*add to THE list of words found.*/
    end   /*until ... */
  end     /*while lines(fn)¬==0*/

say;   call lineout fn                 /*close the file, just to be neat*/
return w                               /*return the index of the word.  */
/*─────────────────────────────────────STRIPPER subroutine──────────────*/
stripper:  procedure;  parse arg q     /*remove punctuation at word-end.*/
@punctuation='.,:;?¿!¡'                /*serveral punctuation marks.    */
                           do j=1  for length(@punctuation)
                           q=strip(q,'T',substr(@punctuation,j,1))
                           end   /*j*/
return q
