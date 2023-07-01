/*REXX pgm finds & shows the sum of elements below the main diagonal of a square matrix.*/
$= '1 3 7 8 10 2 4 16 14 4 3 1 9 18 11 12 14 17 18 20 7 1 3 9 5';       #= words($)
     do siz=1  while siz*siz<#;  end             /*determine the size of the matrix.    */
w= 0                                             /*W:  the maximum width any any element*/
     do j=1  for #;         parse var $  @..j  $ /*obtain a number of the array (list). */
     w= max(w, length(@..j))                     /*examine each element for its width.  */
     end   /*j*/                                 /* [↑] this is aligning matrix elements*/
s= 0;                       z= 0                 /*initialize the sum  [S]  to zero.    */
     do      r=1  for siz;  _= left('', 12)      /*_:  contains a row of matrix elements*/
          do c=1  for siz;  z= z + 1;  @.z= @..z /*get a  number  of the    "      "    */
          _= _  right(@.z, w)                    /*build a row of elements for display. */
          if c<r  then s= s + @.z                /*add a  "lower element"  to the sum.  */
          end   /*r*/
     say _                                       /*display a row of the matrix to term. */
     end        /*c*/
say 'sum of elements below main diagonal is: ' s /*stick a fork in it,  we're all done. */
