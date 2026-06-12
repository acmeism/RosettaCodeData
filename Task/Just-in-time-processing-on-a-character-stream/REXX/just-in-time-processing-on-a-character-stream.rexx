/*REXX program  extracts characters  by using a  book cipher  (that is a  text file).   */
parse arg iFID .                                 /*obtain optional name of file  (book).*/
if iFID=='' | iFID==","  then iFID= 'JIT.TXT'    /*Not specified?  Then use the default.*/
$= 'abcdefghijklmnopqrstuvwxyz';  _=$;  upper _;  $= "0123456789"$ || _;  $$=$ || xrange()
prompt= '────────── enter four positive integers         or        Quit'
pag=1;    lin=1;    FF= 'c'x                     /*assume start of  page 1,  line 1.    */
@.=                                              /*read the entire book from the file.  */
    do  while  lines(iFID)\==0                   /*process lines from input stream(file)*/
    _= translate( linein(iFID), , '9'x)          /*obtain a single line from input file.*/
    if pos(FF, _)\==0  then do; pag=pag+1; lin=1 /*bump page counter; reset line counter*/
                            end                  /* [↑]  handle finding of FF (formfeed)*/
    @.pag.lin= _                                 /*obtain a single line from input file.*/
          lin= lin + 1                           /*bump the line counter.               */
    end   /*while*/                              /* [↑]  read the entire input stream.  */
?=                                               /*define the phrase to be null (so far)*/
       do ask=0;       say prompt;       pull y  /*get just─in─time positional numbers. */
       if abbrev('QUIT', y, 1)  then exit 0      /*the user wants out of here, so exit. */
       y=space( translate(y, $, $$) )            /*allow any separator the user wants.  */
       parse var  y    a.1   a.2   a.3   a.4     /*parse the pertinent parameters.      */
       if words(y)>4   then do;    say 'too many parameters entered.'
                                   iterate  ask
                            end                  /*go and try again to obtain the parms.*/
         do k=1  for 4;  is#= datatype(a.k, 'W') /*validate  parms  {positive integers}.*/
         if is#  then a.k= a.k / 1               /*normalize the number (for indexing). */
         if is#  &  a.k>0  then iterate          /*found a good parameter?   Then skip. */
         say 'parameter '      k      " is missing or not a positive integer: "      a.k
         iterate  ask                            /*go and ask for another set of parms. */
         end   /*k*/                             /* [↑]  done with the validations.     */
       parse value a.1 a.2 a.3 a.4  with p L w c /*parse parameters for specific names. */
       x=substr( word( @.p.L, w), c,  1)         /*extract a character from the book.   */
       if x=='!'  then leave                     /*if the  stop  char was found,  done. */
       say right(x  '◄─── a letter', 46)         /*might as well echo char to terminal. */
       ?= ? || x                                 /*append the character to the phrase.  */
       end   /*j*/                               /* [↑]  display letters found in book. */
say '═════►'   ?                                 /*stick a fork in it,  we're all done. */
