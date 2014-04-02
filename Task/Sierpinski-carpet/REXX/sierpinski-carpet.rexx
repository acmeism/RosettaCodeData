/*REXX program draws any order  Sierpinski carpet  up to order 15.      */
                                       /*order 1k would be 1Mx1M carpet.*/
parse arg n char .                     /*get the order of the carpet.   */
if n=='' | n==','  then n=3            /*if none specified, assume  3.  */
if char==''        then char='*'       /*use the default of an asterisk.*/
if length(char)==2 then char=x2c(char) /*it was specified in hexadecimal*/
if length(char)==3 then char=d2c(char) /*it was specified in decimal.   */
width=132                              /*width of a terminal screen.    */
   do j=0  for 3**n;    z=             /* z is the line to be displayed.*/
       do k=0  for 3**n;    jj=j;  kk=k;  xChar=char
          do  while  jj\==0 & kk\==0   /*one symbol for a not (¬) is  \ */
          if jj//3==1 & kk//3==1  then do             /* // = remainder.*/
                                       xChar=' '      /*use a blank.    */
                                       leave          /*leaves DO while.*/
                                       end
          jj=jj%3
          kk=kk%3                      /*%  means it's integer division.*/
          end   /*while*/
       z=z || xChar                    /*xChar is either black or white.*/
       end   /*k*/
   if length(z)<width  then say z      /*show line if it fits on screen.*/
   call lineout 'Sierpinski.'n, z      /*also, write the line to a file.*/
   end      /*j*/                      /*stick a fork in it, we're done.*/
