/*REXX program to see if a horizontal ray from pt P intersects a polygon*/
call points   5 5,   5 8,  -10  5,  0  5,  10 5,   8 5,  10 10
call polygon  0 0,  10 0,   10 10,  0 10                                 ; call test 'square'
call polygon  0 0, 10 0, 10 10, 0 10, 2.5 2.5, 7.5 2.5, 7.5 7.5, 2.5 7.5 ; call test 'square hole'
call polygon  0 0,  2.5 2.5,   0 10,   2.5 7.5,   7.5 7.5,  10 10,  10 0 ; call test 'irregular'
call polygon  3 0,  7 0,    10 5,   7 10,  3 10,   0 5                   ; call test 'exagon'
exit                                   /*stick a fork in it, we're done.*/
/*──────────────────────────────────IN_OUT subroutine────────────────────*/
in_out: procedure expose point. poly.  /*note: // is division remainder.*/
parse arg p;  #=0;    do side=1 to poly.0 by 2;  #=#+ray_intersect(p,side)
                      end   /*side*/
return #//2                            /*odd=inside,  return 1;  else 0.*/
/*──────────────────────────────────POINTS subroutine───────────────────*/
points:  n=0;  v='POINT.';     do j=1  for arg();  n=n+1
                               call  value v||n'.X', word(arg(j),1)
                               call  value v||n'.Y', word(arg(j),2)
                               end   /*j*/
call value v'0',n                             /*define number of points.*/
return
/*──────────────────────────────────POLYGON subroutine──────────────────*/
polygon:  n=0;  v='POLY.';     parse arg Fx Fy

          do j=1  for arg();   _=arg(j);    n=n+1
          call value v||n'.X', word(_,1);   call value v||n'.Y', word(_,2)
          if n//2  then iterate
          n=n+1
          call value v||n'.X', word(_,1);   call value v||n'.Y', word(_,2)
          end   /*j*/
n=n+1
call value v||n".X", Fx;    call value v||n".Y", Fy;    call value v'0',n
return                                 /*POLY.0  is # of segments/sides.*/
/*──────────────────────────────────RAY_INTERSECT subroutine────────────*/
ray_intersect: procedure expose point. poly.;  parse arg ?,s;   sp=s+1
epsilon  = '1e'||(digits()%2);         infinity = '1e'||(digits()*2)
Px=point.?.x;  Py=point.?.y
Ax=poly.s.x;   Bx=poly.sp.x  ;         Ay=poly.s.y;   By=poly.sp.y
if Ay>By            then  parse value  Ax Ay  Bx By  with  Bx By  Ax Ay
if Py=Ay | Py=By    then  Py=Py+epsilon
if Py<Ay | Py>By |  Px>max(Ax,Bx)   then return 0
if Px<min(Ax,Bx)    then return 1
if Ax\=Bx  then m_red  = (By-Ay) / (Bx-Ax);    else m_red  = infinity
if Ax\=Px  then m_blue = (Py-Ay) / (Px-Ax);    else return 1
return m_blue>=m_red
/*──────────────────────────────────TEST procedure──────────────────────*/
test: say;  do k=1  for point.0        /*traipse through each test point*/
            say '  ['arg(1)"]  point:"   right(point.k.x','point.k.y, 9),
                "  is  "     word('outside inside', in_out(k)+1)
            end   /*k*/
return
