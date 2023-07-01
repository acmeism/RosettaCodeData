/*REXX program uses  a  Shoelace  formula to calculate the area of an  N─sided  polygon.*/
parse arg $;  if $=''  then $= "(3,4),(5,11),(12,8),(9,5),(5,6)"      /*Use the default?*/
A= 0;                  @= space($, 0)                   /*init A; elide blanks from pts.*/
         do #=1  until @=='';      parse var  @    '('   x.#   ","   y.#   ')'   ","   @
         end   /*#*/                                    /* [↨]  get X and Y coördinates.*/
z= #+1;                 y.0= y.#;  y.z= y.1             /*define low & high Y end points*/
         do j=1  for #;  jm= j-1;  jp= j+1;   A= A + x.j*(y.jm - y.jp) /*portion of area*/
         end   /*j*/                                    /*stick a fork in it, we're done*/
say 'polygon area of '      #      " points: "       $       '  is ───► '        abs(A/2)
