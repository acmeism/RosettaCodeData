/*REXX pgm draws a "3D" image of text representation  (*  MUST be used).*/
m.1 = '****                      '
m.2 = '*   *                     '
m.3 = '*   *  ***  *   *  *   *  '
m.4 = '****   *     * *    * *   '
m.5 = '*  *   **     *      *    '
m.6 = '*   *  *     * *    * *   '
m.7 = '*    * ***  *   *  *   *  '
lines=7                                /*number of lines of text for 3D.*/
        do j=1  for lines              /*build the artwork for the text.*/
        A.j.1 =  changestr( " " ,   m.j,     '   '   )    ;  A.j.2 = A.j.1
        A.j.1 =  changestr( "*" ,   A.j.1,   '///'   )" "
        A.j.2 =  changestr( "*" ,   A.j.2,   '\\\'   )" "
        A.j.1 =  changestr( "/ ",   A.j.1,   '/\'    )
        A.j.2 =  changestr( "\ ",   A.j.2,   '\/'    )
          do k=1  for 2;   say strip(left('',lines-j) || A.j.k,'T');   end
        end   /*j*/                    /* [↑] show a line and its shadow*/
                                       /*stick a fork in it, we're done.*/
