/*REXX program multiplies two matrixes together, shows matrixes & result*/
x.=
x.1 = '1 2'
x.2 = '3 4'
x.3 = "5 6"                            /*either kind of quote works.    */
x.4 = '7 8'
            do   r=1 while x.r\==''    /*build the "A" matric from X. #s*/
              do c=1 while x.r\=='';   parse var x.r a.r.c x.r;    end
            end
Arows=r-1;  Acols=c-1
y.=
y.1 =  1 2 3                           /*if all values are positive,    */
y.2 =  4 5 6                           /*can eliminate the quotes.      */
              do   r=1 while y.r\==''  /*build the "B" matric from Y. #s*/
                do c=1 while y.r\=='';    parse var y.r b.r.c y.r;    end
              end
Brows=r-1;  Bcols=c-1
c.=0; L=0                              /*L  is max width of an element. */
           do i        =1 for Arows    /*multiply matrix  A & B  ──�  C */
               do j    =1 for Bcols
                   do k=1 for Acols
                   c.i.j = c.i.j + a.i.k * b.k.j;   L=max(L,length(c.i.j))
                   end   /*k*/
               end       /*j*/
           end           /*i*/

call showMat  'A', Arows, Acols
call showMat  'B', Brows, Bcols
call showMat  'C', Arows, Bcols
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────SHOWMAT subroutine──────────────────*/
showMat:  parse arg mat,rows,cols;   say
say center(mat 'matrix',cols*(L+1)+4,"─")
       do r    =1 for rows; _=
           do c=1 for cols; _=_ right(value(mat'.'r'.'c),L); end;    say _
       end
return
