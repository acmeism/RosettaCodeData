/*REXX program defines (for any 2 points on the curve), returns the sum of the 2 points.*/
numeric digits 100                               /*try to ensure a min. of accuracy loss*/
a= func(1)             ;            say  '    a =              '          show(a)
b= func(2)             ;            say  '    b =              '          show(b)
c= add(a, b)           ;            say  '    c = (a+b)       ='          show(c)
d= neg(c)              ;            say  '    d = -c          ='          show(d)
e= add(c, d)           ;            say  '    e = (c+d)       ='          show(e)
g= add(a, add(b, d))   ;            say  '    g = (a+b+d)     ='          show(g)
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
cbrt:  procedure; parse arg x;                                            return root(x,3)
conv:  procedure; arg z; if isZ(z)  then return 'zero'; return left('',z>=0)format(z,,5)/1
root:  procedure; parse arg x,y;  if x=0 | y=1  then return x/1;   d=5;   return rootI()/1
rootG: parse value format(x,2,1,,0)  'E0'  with  ? 'E' _ .;    return (?/y'E'_ %y) + (x>1)
func:  procedure; parse arg y,k;  if k=='' then k=7;           return cbrt(y**2-k) y
inf:                                                           return '1e' || (digits()%2)
isZ:   procedure; parse arg px . ;                             return abs(px) >= inf()
neg:   procedure; parse arg px py;                             return px         (-py)
show:  procedure; parse arg x  y ;                             return conv(x)  conv(y)
zero:                                                          return inf()    inf()
/*──────────────────────────────────────────────────────────────────────────────────────*/
add:   procedure; parse arg px py, qx qy;     if px=qx & py=qy  then return dbl(px py)
       if isZ(px  py)  then return qx qy;     if isZ(qx qy)     then return     px py
       z= qx - px;       if z=0  then do;     $= inf();         rx= inf();         end
                                 else do;     $= (qy-py) / z;   rx= $*$ - px - qx; end
       ry= $ * (px-rx) - py;                                         return  rx  ry
/*──────────────────────────────────────────────────────────────────────────────────────*/
dbl:   procedure;  parse arg px py;      if isZ(px py)  then return px py;        z= py+py
                   if z=0  then $= inf()
                           else $= (3*px*py) / (py+py)
                   rx= $*$ - px*px;      ry= $ * (px-rx) - py;       return rx ry
/*──────────────────────────────────────────────────────────────────────────────────────*/
rootI: ox=x;  oy=y;  x=abs(x);  y=abs(y);  a=digits()+5;  numeric form;  g=rootG();  m=y-1
          do  until  d==a;    d=min(d+d,a);               numeric digits d;          o=0
            do  until o=g;    o=g;   g=format((m*g**y+x)/y/g**m,,d-2);  end  /*until o=g*/
          end  /*until d==a*/;       _=g*sign(ox);   if oy<0  then _=1/_;         return _
