/*REXX program  demonstrates some  binary  (also known as  bit  or logical)  operations.*/
                        x= 1    ;     y= 0       /*set the initial values of  X  and Y. */
                       @x= ' x ';    @y= ' y '   /*define a couple of literals for HDRs.*/
                                                 /* [↓]  echo  the   X  and  Y   values.*/
call $ 'name', "value"                           /*display the  header  (title) line.   */
call $ 'x'   ,    x                              /*display "x"  and then the value of X.*/
call $ 'y'   ,    y                              /*   "    "y"   "    "   "    "    " Y */
                                                 /* [↓]  negate the X; then the Y value.*/
call $ 'name', "negated"                         /*some REXXes support the  ¬  character*/
call $ 'x'   ,   \x                              /*display "x"  and then the value of ¬X*/
call $ 'y'   ,   \y                              /*   "    "y"   "    "   "    "    " ¬Y*/
say
say
call $ @x, @y, 'AND';    do x=0  to 1;   do y=0  to 1;   call $ x, y, x  & y;    end;  end
call $ @x, @y, 'OR' ;    do x=0  to 1;   do y=0  to 1;   call $ x, y, x  | y;    end;  end
call $ @x, @y, 'XOR';    do x=0  to 1;   do y=0  to 1;   call $ x, y, x && y;    end;  end
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
$: parse arg @.1, @.2, @.3, @.4;         hdr= length(@.1) \== 1;        if hdr  then say
             do j=0  to hdr;             _=
                   do k=1  for arg();    _=_  center(@.k, 7)
                   end   /*k*/
             say _
             @.=copies('═', 7)                   /*define a new header separator line.  */
             end         /*j*/
   return
