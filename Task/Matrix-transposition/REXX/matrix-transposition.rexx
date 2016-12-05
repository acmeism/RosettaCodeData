/*REXX program  transposes  a  matrix,  and  displays the  before and after   matrices. */
x.=;   x.1 = 1.02 2.03 3.04 4.05 5.06 6.07 7.07
       x.2 = 111 2222 33333 444444 5555555 66666666 777777777

                      do    r=1  while x.r\==''        /*build matrix A  from matrix  X.*/
                         do c=1  while x.r\==''
                         parse var  x.r   a.r.c  x.r
                         end   /*c*/
                      end      /*r*/
rows=r-1;  cols=c-1                                    /*adjust for  DO  loop  indices. */
L=0                                                    /*L  is max width element value. */
       do    i=1  for rows
          do j=1  for cols
          b.j.i=a.i.j;       L=max( L, length(b.j.i) )
          end   /*j*/
       end      /*i*/

call showMat 'A', rows, cols
call showMat 'B', cols, rows
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
showMat: parse arg mat,rows,cols;    say;    say center(mat  'matrix',  cols*(L+1)+4, "─")
                   do       r=1  for rows;   _=
                         do c=1  for cols;   _=_ right(value(mat'.'r"."c),  L)
                         end   /*c*/
                   say _
                   end         /*r*/
         return
