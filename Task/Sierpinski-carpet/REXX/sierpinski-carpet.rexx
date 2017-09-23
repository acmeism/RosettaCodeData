/*REXX program draws any order Sierpinski carpet (order 20 would be ≈ 3.4Gx3.4G carpet).*/
parse arg N char .                               /*get the  order  of the carpet.       */
if N==''  |  N==","  then N=3                    /*if none specified, then assume  3.   */
if char==''          then char="*"               /*use the default of an asterisk  (*). */
if length(char)==2   then char=x2c(char)         /*it was specified in hexadecimal char.*/
if length(char)==3   then char=d2c(char)         /* "  "      "      " decimal character*/
width=linesize()                                 /*the width of the terminal screen.    */
if N>18  then numeric digits 100                 /*just in case the user went  ka─razy. */
nnn=3**N                                         /* [↓]  NNN  is the  cube of  N.       */

  do   j=0  for nnn;   z=                        /*Z:    is the line to be displayed.   */
    do k=0  for nnn;   jj=j;   kk=k;   x=char
      do  while  jj\==0  &  kk\==0               /*one symbol for a  not (¬)  is a   \  */
      if jj//3==1  then if kk//3==1  then do     /*in REXX:    //  ≡  division remainder*/
                                          x=' '  /*use a blank for this display line.   */
                                          leave  /*LEAVE   terminates this   DO  WHILE. */
                                          end
      jj=jj%3;      kk=kk%3                      /*in REXX:     %  ≡  integer division. */
      end   /*while*/

    z=z || x                                     /*xChar  is either  black  or  white.  */
    end     /*k*/                                /* [↑]    "    "      "     "  blank.  */

  if length(z)<width  then say z                 /*display the line if it fits on screen*/
  call lineout 'Sierpinski.'N, z                 /*also, write the line to a (disk) file*/
  end       /*j*/                                /*stick a fork in it,  we're all done. */
