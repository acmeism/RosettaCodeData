/*REXX program uses Cramer's rule to find and display solution of given linear equations*/
values=     '-3 -32 -47 49'                      /*values of each matrix row of numbers.*/
variables= substr('abcdefghijklmnopqrstuvwxyz', 27 - words(values) )   /*variable names.*/
call makeM  ' 2  -1   5  1        3   2   2  -6        1   3   3  -1        5  -2  -3   3'
              do   y=1  for sz;  $=              /*display the matrix (linear equations)*/
                do x=1  for sz;  $= $ right(psign(@.x.y), w)'*'substr(variables, x, 1)
                end   /*y*/                      /* [↑]   right─justify matrix elements.*/
              pad= left('', length($) - 2);    say $   ' = '   right( word(values, y), wv)
              end     /*x*/                      /* [↑]   obtain value of the equation. */
say; say
              do     k=1  for sz                 /*construct the nominator matrix.      */
                do   j=1  for sz
                  do i=1  for sz;  if i==k  then !.i.j= word(values, j)
                                            else !.i.j= @.i.j
                  end   /*i*/
                end     /*j*/
              say pad substr(variables,k,1) ' = ' right(det(makeL())/det(mat), digits()+2)
              end       /*k*/
exit 0                                           /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
makeL: $=; do x=1  for sz; do y=1  for sz; $= $ !.x.y; end; end; return $ /*matrix─►list*/
mSize: arg _; do sz=0 for 1e3; if sz*sz==_ then return; end; say 'error,bad matrix';exit 9
psign: parse arg num;  if left(num, 1)\=='-'  &  x>1  then return "+"num;   return num
/*──────────────────────────────────────────────────────────────────────────────────────*/
det: procedure;  parse arg a b c d 1 nums;        call mSize words(nums);    _= 0
     if sz==2  then return a*d  -  b*c
              do   j=1  for sz
                do i=1  for sz;    _= _ + 1;      @.i.j= word(nums, _)
                end   /*i*/
              end
     aa= 0
              do     i=1  for sz;  odd= i//2;     $=
                do   j=2  for sz-1
                  do k=1  for sz;  if k\==i  then $= $  @.k.j
                  end   /*k*/
                end     /*j*/
              aa= aa   -   (-1 ** odd)  *  @.i.1  *  det($)
              end;      /*i*/;                                               return aa
/*──────────────────────────────────────────────────────────────────────────────────────*/
makeM: procedure expose @. values mat sz w wv;  parse arg mat;    call mSize words(mat)
       #= 0;                     wv= 0;                           w= 0
              do   j=1  for sz;  wv= max(wv, length( word( values, j) ) )
                do k=1  for sz;  #= #+1;  @.k.j= word(mat, #);    w= max(w, length(@.k.j))
                end   /*k*/
              end;    /*j*/;     w= w + 1;                                   return
