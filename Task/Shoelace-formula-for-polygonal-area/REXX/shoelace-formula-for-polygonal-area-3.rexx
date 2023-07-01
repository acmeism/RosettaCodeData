/*REXX program uses a  Shoelace  formula to calculate the area of an  N-sided  polygon. */
parse arg pts                                    /*obtain optional arguments from the CL*/
if pts='' then pts= '(3,4),(5,11),(12,8),(9,5),(5,6)'   /*Not specified?   Use default. */
pts=space(pts,0); z=pts                                 /*elide extra blanks;  save pts.*/
do n=1 until z=''                                       /*perform destructive parse on z*/
  parse var z '(' x.n ',' y.n ')' ',' z                 /*obtain X and Y coördinates    */
  end
z=n+1; y.z=y.1                                          /* take care of end points      */
       y.0=y.n
A=0                                                     /*initialize the  area  to zero.*/
do j=1 for n;
  jp=j+1;
  jm=j-1;
  A=A+x.j*(y.jp-y.jm)                                   /*compute a part of the area.   */
  end
A=abs(A/2)                                              /*obtain half of the  ¦ A ¦  sum*/
say 'polygon area of' n 'points:' pts 'is --->' A
