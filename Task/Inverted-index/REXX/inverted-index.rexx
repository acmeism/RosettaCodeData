/*REXX program illustrates building a simple inverted index  and  a method of word find.*/
@.=                                              /*a dictionary of words   (so far).    */
!=                                               /*a list of found words   (so far).    */
call invertI 0, 'BURMA0.TXT'                     /*read the file:  BURMA0.TXT  ···      */
call invertI 1, 'BURMA1.TXT'                     /*  "   "    "    BURMA1.TXT  ···      */
call invertI 2, 'BURMA2.TXT'                     /*  "   "    "    BURMA2.TXT  ···      */
call invertI 3, 'BURMA3.TXT'                     /*  "   "    "    BURMA3.TXT  ···      */
call invertI 4, 'BURMA4.TXT'                     /*  "   "    "    BURMA4.TXT  ···      */
call invertI 5, 'BURMA5.TXT'                     /*  "   "    "    BURMA5.TXT  ···      */
call invertI 6, 'BURMA6.TXT'                     /*  "   "    "    BURMA6.TXT  ···      */
call invertI 7, 'BURMA7.TXT'                     /*  "   "    "    BURMA7.TXT  ···      */
call invertI 8, 'BURMA8.TXT'                     /*  "   "    "    BURMA8.TXT  ···      */
call invertI 9, 'BURMA9.TXT'                     /*  "   "    "    BURMA9.TXT  ···      */
call findAword  "huz"                            /*find a word.                         */
call findAword  "60"                             /*find another word.                   */
call findAword  "don't"                          /*and find another word.               */
call findAword  "burma-shave"                    /*and find yet another word.           */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
findAword: procedure expose @.;  arg x           /*get an uppercase version of the X arg*/
           parse arg ox                          /*get original (as-is)  value of X arg.*/
           _=@.x;    oxo='───'ox"───"
           if _==''  then do
                          say 'word'   oxo   "not found."
                          return 0
                          end
           _@=_                                  /*save _ text, pass it back to invoker.*/
           say 'word'  oxo  "found in:"
                          do  until _=='';    parse var   _   f  w  _
                          say '       file='f   "  word="w
                          end   /*until ··· */
           return _@
/*──────────────────────────────────────────────────────────────────────────────────────*/
invertI:   procedure expose @. !; parse arg #,fn /*the file number and the filename.    */
           call lineout fn                       /*close the file, ··· just in case.    */
           w=0                                   /*the number of words found  (so far). */
               do  while lines(fn)\==0           /* [↓]   process the entire file.      */
               _=space( linein(fn) )             /*read a line, elide superfluous blanks*/
               if _==''  then iterate            /*if a blank record,  then ignore it.  */
               say 'file' #", record:" _         /*display the record ──► terminal.     */

                  do  until _==''                /*pick off words from record until done*/
                  parse upper var   _   ?  _     /*pick off a word  (it's in uppercase).*/
                  ?=stripper(?)                  /*strip any trailing punctuation.      */
                  if ?=''  then iterate          /*is the word now all blank (or null)? */
                  w=w+1                          /*bump the word counter (index).       */
                  @.?=@.?  #  w                  /*append the new word to a list.       */
                  if wordpos(?,!)==0  then !=! ? /*add it to the list of words found.   */
                  end   /*until ··· */
               end      /*while ··· */
           say;     call lineout fn              /*close the file, just to be neat&safe.*/
           return w                              /*return the index of word in record.  */
/*──────────────────────────────────────────────────────────────────────────────────────*/
stripper:  procedure;  parse arg q               /*remove punctuation at the end of word*/
           @punctuation= '.,:;?¿!¡∙·';        do j=1  for length(@punctuation)
                                              q=strip(q, 'T', substr(@punctuation, j, 1) )
                                              end   /*j*/
           return q
