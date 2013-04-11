/*REXX program to show some binary  (AKA  bit  or logical)  operations. */
x=1;   y=0
    /*═════════════════════════════════════════════════echo   X,Y values*/
call TT 'name', "value"
call TT 'x'   ,    x
call TT 'y'   ,    y
    /*═════════════════════════════════════════════════negate X,Y values*/
call TT 'name', "negated"
call TT 'x'   ,   \x                 /*some REXXes support the  ¬  char.*/
call TT 'y'   ,   \y
    /*═════════════════════════════════════════════════AND    X,Y values*/
call TT 'value','value',"AND";   do    x=0 to 1
                                    do y=0 to 1;  call TT x,y, x & y;  end
                                 end
    /*═════════════════════════════════════════════════OR     X,Y values*/
call TT 'value','value',"OR";    do    x=0 to 1
                                    do y=0 to 1;  call TT x,y, x | y;  end
                                 end
    /*═════════════════════════════════════════════════XOR    X,Y values*/
call TT 'value','value',"XOR";   do   x=0 for 2
                                   do y=0 for 2;  call TT x,y, x && y; end
                                 end
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────TT subroutine───────────────────────*/
TT: parse arg a.1,a.2,a.3,a.4;  hdr=length(a.1)\==1; if hdr then say;  w=7
         do TT=0 to hdr;    _=
               do k=1 for arg();     _=_ center(a.k,w);     end   /*k*/
         say _
         a.=copies('─',w)
         end   /*TT*/
return
