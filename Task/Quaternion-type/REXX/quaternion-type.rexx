/*REXX pgm performs some operations on quaternion type numbers and shows results*/
                  q = 1 2 3 4    ;              q1 = 2 3 4 5
                  r = 7          ;              q2 = 3 4 5 6
call qShow  q                    ,   'q'
call qShow  q1                   ,   'q1'
call qShow  q2                   ,   'q2'
call qShow  r                    ,   'r'
call qShow  qNorm(q)             ,   'norm q'                 ,     "task 1:"
call qShow  qNeg(q)              ,   'negative q'             ,     "task 2:"
call qShow  qConj(q)             ,   'conjugate q'            ,     "task 3:"
call qShow  qAdd( r, q  )        ,   'addition r+q'           ,     "task 4:"
call qShow  qAdd(q1, q2 )        ,   'addition q1+q2'         ,     "task 5:"
call qShow  qMul( q, r  )        ,   'multiplication q*r'     ,     "task 6:"
call qShow  qMul(q1, q2 )        ,   'multiplication q1*q2'   ,     "task 7:"
call qShow  qMul(q2, q1 )        ,   'multiplication q2*q1'   ,     "task 8:"
exit                                   /*stick a fork in it,  we're all done.   */
/*──────────────────────────────────────────────────────────────────────────────*/
qConj: procedure;  parse arg x;  call qXY;        return  x.1 (-x.2) (-x.3) (-x.4)
qNeg:  procedure;  parse arg x;  call qXY;        return -x.1 (-x.2) (-x.3) (-x.4)
/*──────────────────────────────────────────────────────────────────────────────*/
qAdd: procedure; parse arg x,y; call qXY 2; return x.1+y.1 x.2+y.2 x.3+y.3 x.4+y.4
/*──────────────────────────────────────────────────────────────────────────────*/
qMul:  procedure; parse arg x,y;  call qXY y
           return x.1*y.1-x.2*y.2-x.3*y.3-x.4*y.4 x.1*y.2+x.2*y.1+x.3*y.4-x.4*y.3,
                  x.1*y.3-x.2*y.4+x.3*y.1+x.4*y.2 x.1*y.4+x.2*y.3-x.3*y.2+x.4*y.1
/*──────────────────────────────────────────────────────────────────────────────*/
qNorm: procedure; parse arg x; call qXY;  return sqrt(x.1**2+x.2**2+x.3**2+x.4**2)
/*──────────────────────────────────────────────────────────────────────────────*/
qShow: procedure; parse arg x;    call qXY;   $=
             do m=1  for 4; _=x.m;  if _==0  then iterate;    if _>=0  then _='+'_
             if m\==1  then _=_ || substr('~ijk',m,1);        $=strip($ || _,,'+')
             end   /*m*/
       say left(arg(3),9)   right(arg(2),20)        ' ──► '           $
       return $
/*──────────────────────────────────────────────────────────────────────────────*/
qXY:                      do n=1  for 4;  x.n=word(word(x,n) 0,1)/1;  end /*n*/
       if arg()==1  then  do m=1  for 4;  y.m=word(word(y,m) 0,1)/1;  end /*m*/
       return
/*──────────────────────────────────────────────────────────────────────────────*/
sqrt:  procedure; parse arg x;   if x=0  then return 0;   d=digits();   i=;   m.=9
       numeric digits 9; numeric form;  h=d+6;  if x<0  then  do; x=-x; i='i'; end
       parse value format(x,2,1,,0) 'E0'  with  g 'E' _ .;        g=g*.5'e'_%2
          do j=0  while h>9;      m.j=h;                h=h%2+1;        end  /*j*/
          do k=j+5  to 0  by -1;  numeric digits m.k;   g=(g+x/g)*.5;   end  /*k*/
       numeric digits d;     return (g/1)i            /*make complex if  X < 0. */
