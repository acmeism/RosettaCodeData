/*REXX program uses the  Runge─Kutta  method to solve the equation:   y'(t)=t² √[y(t)]  */
numeric digits 40;       f=digits() % 4          /*use 40 decimal digs, but only show 10*/
x0=0;          x1=10;    dx= .1                  /*define variables:    X0   X1   DX    */
n=1 + (x1-x0) / dx
y.=1;                    do m=1  for n-1;   p=m-1;    y.m=RK4(dx,  x0 + dx*p,  y.p)
                         end   /*m*/             /*   [↑]  use 4th order Runge─Kutta.   */
w=digits() % 2                                   /*W: width used for displaying numbers.*/
say center('X', f, "═")  center('Y', w+2, "═")  center("relative error", w+8, '═') /*hdr*/

                do i=0  to n-1  by 10;  x=(x0 + dx*i) / 1;           $=y.i/(x*x/4+1)**2 -1
                say  center(x, f)     fmt(y.i)     left('', 2 + ($>=0) )        fmt($)
                end   /*i*/                      /*└┴┴┴───◄─────── aligns positive #'s. */
exit                                             /*stick a fork in it,  we're all done. */
/*──────────────────────────────────────────────────────────────────────────────────────*/
fmt:  z=right( format( arg(1), w, f), w);     hasE=pos('E', z)\==0;     has.=pos(., z)\==0
      jus=has. & \hasE;        if jus  then z=left( strip( strip(z, 'T', 0),  "T", .),  w)
      return translate(right(z, (z>=0) +  w  +  5*hasE  +  2*(jus & (z<0) ) ),  'e',  "E")
/*──────────────────────────────────────────────────────────────────────────────────────*/
RK4:  procedure; parse arg dx,x,y;   dxH=dx/2;    k1= dx  *  (x      )  *  sqrt(y       )
                                                  k2= dx  *  (x + dxH)  *  sqrt(y + k1/2)
                                                  k3= dx  *  (x + dxH)  *  sqrt(y + k2/2)
                                                  k4= dx  *  (x + dx )  *  sqrt(y + k3  )
      return y + (k1 + k2*2 + k3*2 + k4) / 6
/*──────────────────────────────────────────────────────────────────────────────────────*/
sqrt: procedure; parse arg x; if x=0  then return 0; d=digits(); m.=9; numeric form; h=d+6
      numeric digits;  parse value format(x,2,1,,0) 'E0' with g 'E' _ .;  g=g * .5'e'_ % 2
        do j=0  while h>9;      m.j=h;               h=h%2+1;       end /*j*/
        do k=j+5  to 0  by -1;  numeric digits m.k;  g=(g+x/g)*.5;  end /*k*/;    return g
