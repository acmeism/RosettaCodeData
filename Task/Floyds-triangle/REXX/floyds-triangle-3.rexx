/*REXX program constructs & displays Floyd's triangle for any number of rows in base 16.*/
parse arg rows .;  if rows==''  then rows=6      /*Not specified?  Then use the default.*/
mx=rows * (rows+1) % 2                           /*calculate maximum value of any value.*/
say 'displaying a ' rows " row Floyd's triangle in base 16:";   say  /*show triangle hdr*/
#=1
    do     r=1  for rows;   i=0;         _=      /*construct Floyd's triangle row by row*/
        do #=#  for r;      i=i+1                /*start to construct a row of triangle.*/
        _=_ right(d2x(#),length(d2x(mx-rows+i))) /*build a row of the Floyd's triangle. */
        end   /*#*/
    say substr(_,2)                              /*remove 1st leading blank in the line,*/
    end       /*r*/                              /* [↑]   introduced by first abutment. */
                                                 /*stick a fork in it,  we're all done. */
