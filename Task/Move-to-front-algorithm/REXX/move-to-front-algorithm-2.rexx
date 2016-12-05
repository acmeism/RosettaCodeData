/*REXX program demonstrates the  move─to─front  algorithm  encode/decode  symbol table. */
parse arg xxx;   if xxx=''  then xxx= 'broood bananaaa hiphophiphop'  /*use the default?*/
                 one=1                           /*(offset) for this task's requirement.*/
  do j=1  for words(xxx);   x=word(xxx, j)       /*process a single word at a time.     */
  @= 'abcdefghijklmnopqrstuvwxyz';    @@=@       /*symbol table: the lowercase alphabet */
  $=                                             /*set the decode string to a   null.   */
       do k=1  for length(x);  z=substr(x, k, 1) /*encrypt a symbol in the word.        */
       _=pos(z, @);   if _==0  then iterate      /*the symbol position in symbol table. */
       $=$ _ - one;   @=z || delstr(@, _, 1)     /*adjust the symbol table string.      */
       end   /*k*/                               /* [↑]  the  move─to─front  encoding.  */
  !=                                             /*set the encode string to a   null.   */
       do m=1  for words($);   n=word($, m) +one /*decode the sequence table string.    */
       y=substr(@@, n, 1);      !=! || y         /*the decode symbol for the word.      */
       @@=y || delstr(@@, n, 1)                  /*rebuild the symbol table string.     */
       end   /*m*/                               /* [↑]  the  move─to─front  decoding.  */

  say '  word: '   left(x, 20)    "encoding:"   left($, 35)    word('wrong OK', 1+(!==x) )
  end   /*j*/                                    /*stick a fork in it,  we're all done. */
