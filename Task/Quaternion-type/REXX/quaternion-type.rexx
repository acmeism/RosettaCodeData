/*REXX program to perform simple operations of  quaternion type numbers.*/
                  q = 1 2 3 4  ;            q1 = 2 3 4 5
                  r = 7        ;            q2 = 3 4 5 6
call quatShow q                , 'q'
call quatShow q1               , 'q1'
call quatShow q2               , 'q2'
call quatShow r                , 'r'
call quatShow quatNorm(q)      , 'norm q'                 , "task 1:"
call quatShow quatNeg(q)       , 'negative q'             , "task 2:"
call quatShow quatConj(q)      , 'conjugate q'            , "task 3:"
call quatShow quatAdd( r, q  ) , 'addition r+q'           , "task 4:"
call quatShow quatAdd(q1, q2 ) , 'addition q1+q2'         , "task 5:"
call quatShow quatMul( q, r  ) , 'multiplication q*r'     , "task 6:"
call quatShow quatMul(q1, q2 ) , 'multiplication q1*q2'   , "task 7:"
call quatShow quatMul(q2, q1 ) , 'multiplication q2*q1'   , "task 8:"
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────QUATADD─────────────────────────────*/
quatAdd: procedure; parse arg x,y;  call quatXY 2
return  x.1+y.1   x.2+y.2   x.3+y.3   x.4+y.4
/*──────────────────────────────────QUATCONJ────────────────────────────*/
quatConj: procedure; parse arg x;   call quatXY
return  x.1  (-x.2)  (-x.3)  (-x.4)
/*──────────────────────────────────QUATMUL─────────────────────────────*/
quatMul: procedure; parse arg x,y;  call quatXY y
return  x.1*y.1-x.2*y.2-x.3*y.3-x.4*y.4   x.1*y.2+x.2*y.1+x.3*y.4-x.4*y.3,
        x.1*y.3-x.2*y.4+x.3*y.1+x.4*y.2   x.1*y.4+x.2*y.3-x.3*y.2+x.4*y.1
/*──────────────────────────────────QUATNEG─────────────────────────────*/
quatNeg: procedure; parse arg x;    call quatXY
return -x.1  (-x.2)  (-x.3)  (-x.4)
/*──────────────────────────────────QUATNORM────────────────────────────*/
quatNorm: procedure; parse arg x;   call quatXY
return sqrt(x.1**2 + x.2**2 + x.3**2 + x.4**2)
/*──────────────────────────────────QUATSHOW────────────────────────────*/
quatShow: procedure; parse arg x;   call quatXY;   quat=
   do m=1  for 4; _=x.m;  if _==0 then iterate; if _ >=0  then _='+'_
   if m\==1  then _=_||substr('~ijk',m,1)     ; quat=strip(quat || _,,'+')
   end   /*m*/
say  left(arg(3),9)  right(arg(2),20)   ' ──► '   quat
return quat
/*──────────────────────────────────QUATXY──────────────────────────────*/
quatXY:            do n=1  for 4;   x.n=word(word(x,n) 0,1)/1;  end  /*n*/
if arg()==1  then  do m=1  for 4;   y.m=word(word(y,m) 0,1)/1;  end  /*m*/
return
/*──────────────────────────────────SQRT subroutine─────────────────────*/
sqrt: procedure;parse arg x;if x=0 then return 0;d=digits();numeric digits 11
m.=11;numeric form;p=d+d%4+2;parse value format(x,2,1,,0) 'E0' with g 'E' _ .
g=g*.5'E'_%2;   do j=0 while p>9; m.j=p; p=p%2+1; end;   do k=j+5 to 0 by -1
if m.k>11 then numeric digits m.k;g=.5*(g+x/g);end;numeric digits d;return g/1
