/*REXX program multiplies 2 matrixes together, shows matrixes and result*/
x.  =                                  /*the beginnings of the A matrix.*/
x.1 =  1 2                             /*╔═════════════════════════════╗*/
x.2 =  3 4                             /*║As none of the values haven't║*/
x.3 =  5 6                             /*║a sign, quotes aren't needed.║*/
x.4 =  7 8                             /*╚═════════════════════════════╝*/
             do   r=1  while x.r\==''  /*build the "A" matric from X. #s*/
               do c=1  while x.r\=='';   parse var x.r a.r.c x.r;      end
             end   /*r*/
Arows=r-1                              /*adjust number of rows (DO loop)*/
Acols=c-1                              /*   "      "    " cols   "   "  */
y.  =                                  /*the beginnings of the B matrix.*/
y.1 =  1 2 3
y.2 =  4 5 6
             do   r=1  while y.r\==''  /*build the "B" matric from Y. #s*/
               do c=1  while y.r\=='';   parse var y.r b.r.c y.r;      end
             end
Brows=r-1                              /*adjust number of rows (DO loop)*/
Bcols=c-1                              /*   "      "    " cols   "   "  */
c.=0;  L=0                             /*L   is max width of an element.*/
             do i      =1  for Arows   /*multiply matrix  A & B  ──►  C */
               do j    =1  for Bcols
                   do k=1  for Acols
                   c.i.j = c.i.j + a.i.k * b.k.j;   L=max(L,length(c.i.j))
                   end   /*k*/
               end       /*j*/
             end         /*i*/

call showMatrix  'A',  Arows,  Acols   /*display matrix A ───► terminal.*/
call showMatrix  'B',  Brows,  Bcols   /*   "       "   B ───►     "    */
call showMatrix  'C',  Arows,  Bcols   /*   "       "   C ───►     "    */
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOWMATRIX subroutine───────────────*/
showMatrix:  parse arg mat,rows,cols;   say
say center(mat 'matrix',cols*(L+1)+4,"─")
       do r    =1 for rows; _=
           do c=1 for cols; _=_ right(value(mat'.'r'.'c),L); end;    say _
       end   /*r*/
return
