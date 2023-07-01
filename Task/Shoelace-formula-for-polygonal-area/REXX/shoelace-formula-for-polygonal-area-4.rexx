/*REXX program uses a  Shoelace  formula to calculate the area of an  N-sided  polygon. */
parse arg pts                                    /*obtain optional arguments from the CL*/
if pts='' then pts= '(3,4),(5,11),(12,8),(9,5),(5,6)'   /*Not specified?   Use default. */
pts=space(pts,0); z=pts                                 /*elide extra blanks;  save pts.*/
do n=1 until z=''                                       /*perform destructive parse on z*/
  parse var z '(' x.n ',' y.n ')' ',' z                 /*obtain X and Y coördinates    */
  end
a=0
Do i=1 To n-1
  j=i+1
  a=a+x.i*y.j-x.j*y.i
  End
a=a+x.n*y.1-x.1*y.n
a=abs(a)/2
say 'polygon area of' n 'points:' pts 'is --->' a
