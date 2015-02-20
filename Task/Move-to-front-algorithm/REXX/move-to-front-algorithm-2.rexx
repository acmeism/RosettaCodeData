/*REXX pgm demonstrates move─to─front algorithm encode/decode sym table.*/
parse arg xxx;   if xxx=''  then xxx='broood bananaaa hiphophiphop'
                 one=1                      /*for task's requirement.   */
  do j=1  for words(xxx);   x=word(xxx,j)   /*process one word at a time*/
  @='abcdefghijklmnopqrstuvwxyz'            /*sym table: lower alphabet.*/
  $=                                        /*set decode string to null.*/
     do k=1  for length(x); z=substr(x,k,1) /*encrypt a char in word.   */
     _=pos(z,@);     if _==0  then iterate  /*char position in sym table*/
     $=$ _-one;      @=z || delstr(@,_,1)   /*adjust the symbol table.  */
     end   /*k*/                            /* [↑]  move─to─front encode*/

  @='abcdefghijklmnopqrstuvwxyz'            /*sym table: lower alphabet.*/
  !=                                        /*set encode string to null.*/
     do m=1  for words($);  n=word($,m)+one /*decode the sequence table.*/
     y=substr(@,n,1);       !=! || y        /*decode character of word. */
     @=y || delstr(@,n,1)                   /*rebuild the symbol table. */
     end   /*m*/                            /* [↑]  move─to─front decode*/

  say 'word: ' left(x,20) "encoding:" left($,35) word('wrong OK',1+(!==x))
  end  /*j*/                           /*done encoding/decoding words.  */
                                       /*stick a fork in it, we're done.*/
