/*REXX program  demonstrates some  binary  (also known as  bit  or logical)  operations.*/
         x=1;      y=0;      @v= 'value'         /*set initial values of X & Y; literal.*/
                                                 /* [↓]  echo  the   X  and  Y   values.*/
call TT 'name', "value"                          /*display the  header  (title) line.   */
call TT 'x'   ,    x                             /*display "x"  and then the value of X.*/
call TT 'y'   ,    y                             /*   "    "y"   "    "   "    "    " Y */
                                                 /* [↓]  negate the X; then the Y value.*/
call TT 'name', "negated"                        /*some REXXes support the  ¬  character*/
call TT 'x'   ,   \x                             /*display "x"  and then the value of ¬X*/
call TT 'y'   ,   \y                             /*   "    "y"   "    "   "    "    " ¬Y*/
                                                 /*both DO loops use 0 and 1 for values.*/
call TT @v, @v, 'AND';   do x=0 for 2;    do y=0 for 2;  call TT x, y, x  & y;   end /*y*/
                         end   /*x*/

call TT @v, @v, 'OR';    do x=0 for 2;    do y=0 for 2;  call TT x, y, x  | y;   end /*y*/
                         end   /*x*/

call TT @v, @v, 'XOR';   do x=0 for 2;    do y=0 for 2;  call TT x, y, x && y;   end /*y*/
                         end   /*x*/
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
TT: parse arg @.1,@.2,@.3,@.4;  hdr=length(@.1)\==1;       if hdr  then say;    w=7
             do j=0  to hdr;   _=;    do k=1  for arg();   _=_ center(@.k,w);   end  /*k*/
             say _
             @.=copies('═', w)                   /*define the header separator line.    */
             end   /*j*/                         /*W:  is used for the width of a column*/
    return
