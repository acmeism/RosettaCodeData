/*REXX pgm draws a "3D" image of text representation;  any character except  /  and  \  */
#=7;                       @.1 =  '@@@@                        '
                           @.2 =  '@   @                       '
                           @.3 =  '@   @   @@@@  @   @  @   @  '
                           @.4 =  '@@@@    @      @ @    @ @   '
                           @.5 =  '@  @    @@@     @      @    '
                           @.6 =  '@   @   @      @ @    @ @   '
                           @.7 =  '@    @  @@@@  @   @  @   @  '
  do j=1  for #;  x=left(strip(@.j),1)           /* [↓]  display the (above) text lines.*/
  $.1 = changestr( " " ,   @.j,   '   '   )       ;      $.2 = $.1
  $.1 = changestr(  x  ,   $.1,   '///'   )" "
  $.2 = changestr(  x  ,   $.2,   '\\\'   )" "
  $.1 = changestr( "/ ",   $.1,   '/\'    )
  $.2 = changestr( "\ ",   $.2,   '\/'    )
       do k=1  for 2;  say strip(left('',#-j)$.k,"T")   /*the LEFT BIF does indentation.*/
       end  /*k*/                                /* [↑]  display a line  and its shadow.*/
  end       /*j*/                                /*stick a fork in it,  we're all done. */
