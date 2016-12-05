/*REXX program multiplies two matrices together, displays the matrices and the results. */
x.=;  x.1=1 2                                    /*╔═══════════════════════════════════╗*/
      x.2=3 4                                    /*║ As none of the matrix values have ║*/
      x.3=5 6                                    /*║ a sign,  quotes aren't needed.    ║*/
      x.4=7 8                                    /*╚═══════════════════════════════════╝*/
                 do   r=1  while x.r\==''        /*build the "A" matrix from X. numbers.*/
                   do c=1  while x.r\=='';   parse var x.r a.r.c x.r;      end  /*c*/
                 end   /*r*/
Arows=r-1                                        /*adjust the number of rows  (DO loop).*/
Acols=c-1                                        /*   "    "     "    " cols    "   "  .*/
y.=;  y.1=1 2 3
      y.2=4 5 6
                 do   r=1  while y.r\==''        /*build the "B" matrix from Y. numbers.*/
                   do c=1  while y.r\=='';   parse var y.r b.r.c y.r;      end  /*c*/
                 end   /*r*/
Brows=r-1                                        /*adjust the number of rows  (DO loop).*/
Bcols=c-1                                        /*   "     "    "    " cols    "   "   */
c.=0;  w=0                                       /*W  is max width of an matrix element.*/
            do       i=1  for Arows              /*multiply matrix  A  and  B  ───►   C */
              do     j=1  for Bcols
                  do k=1  for Acols;    c.i.j=c.i.j  +  a.i.k * b.k.j
                                                     w=max(w, length(c.i.j))
                  end   /*k*/                    /*  ↑                                  */
              end       /*j*/                    /*  └──◄─── maximum width of elements. */
            end         /*i*/

call showMatrix  'A',  Arows,  Acols             /*display matrix  A ───►  the terminal.*/
call showMatrix  'B',  Brows,  Bcols             /*   "       "    B ───►   "     "     */
call showMatrix  'C',  Arows,  Bcols             /*   "       "    C ───►   "     "     */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
showMatrix: parse arg mat,rows,cols;   say;   say center(mat 'matrix', cols*(w+1) +4, "─")
                    do   r=1  for rows;  _=
                      do c=1  for cols;  _=_ right(value(mat'.'r"."c), w);  end;     say _
                    end   /*r*/
            return
