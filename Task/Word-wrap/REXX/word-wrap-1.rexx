/*REXX pgm reads a file and displays it (with word wrap to the screen). */
parse arg iFID width                   /*get optional arguments from CL.*/
@=                                     /*nullify the text  (so far).    */
    do j=0  while lines(iFID)\==0      /*read from the file until E-O-F.*/
    @=@ linein(iFID)                   /*append the file's text to  @   */
    end   /*j*/
$=word(@,1)
    do k=2 for words(@)-1; x=word(@,k) /*parse until text (@) exhausted.*/
    _=$ x                              /*append it to the money and see.*/
    if length(_)>width  then do        /*words exceeded the width?      */
                             say $     /*display what we got so far.    */
                             _=x       /*overflow for the next line.    */
                             end
    $=_                                /*append this word to the output.*/
    end   /*k*/
if $\==''  then say $                  /*handle any residual words.     */
                                       /*stick a fork in it, we're done.*/
