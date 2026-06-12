/* REXX ****************************************************************
* Triangle computes data about a given triangle
* The circumcircle is what we need here
***********************************************************************/
call triangle 10 10 200 10 100 200
Exit
triangle:
/***********************************************************************
* Triangle Computations
* 940810 PA  new
* 220624 a mere 38 years later completed and anglisized
***********************************************************************/
  Parse Arg ax ay bx by cx cy
  If ax='?' Then Do
    Say 'REXX Triangle ax ay bx by cx cy'
    Say ' computes miscellaneous data about this triangle'
    Exit
    End
  If ax='' Then Do
    d='D 0 0 10 0 5 10'
    Parse Var d . ax ay bx by cx cy .
    End
  Else
    d='D' ax ay bx by cx cy .
  Say ''
  Say 'Triangle ABC:'
  A='P' ax ay  ; Say 'A' rep(A)
  B='P' bx by  ; Say 'B' rep(B)
  C='P' cx cy  ; Say 'C' rep(C)

  areal=a(. ax ay bx by cx cy)
  If areal<1e-3 Then
    Call ex 'This isn''t a Triangle!! area='areal
  Say ''
  Say 'Triangle''s sides:'
  al=dist(B,C) ; Say 'B-C a='round(al)
  bl=dist(C,A) ; Say 'C-A b='round(bl)
  cl=dist(A,B) ; Say 'A-B c='round(cl)

  /* c**2=a**2+b**2-2*a*b*cos(gamma) */
  cnvf=180/rxcalcpi() -- 57.2957796
  alpha=rxCalcarccos((bl**2+cl**2-al**2)/(2*bl*cl),,'R')*cnvf
  beta =rxCalcarccos((al**2+cl**2-bl**2)/(2*al*cl),,'R')*cnvf
  gamma=rxCalcarccos((al**2+bl**2-cl**2)/(2*al*bl),,'R')*cnvf
  Say ''
  Say 'Triangle''s angles:'
  Say 'alpha='round(alpha)
  Say 'beta ='round(beta)
  Say 'gamma='round(gamma)
  Say 'sum  ='round(alpha+beta+gamma)

  Say ''
  Say 'Angle-bisectors:'
  wsa=ws(A,C,B); Say 'wsA' left(rep(wsA),20)
  wsb=ws(B,A,C); Say 'wsB' left(rep(wsB),20)
  wsc=ws(C,A,B); Say 'wsC' left(rep(wsC),20)

  ha=normale(A,g(B,C))
  Call dbg  'HA' rep(ha) ha
  hb=normale(B,g(A,C))
  Call dbg  'HB' rep(hb) hb
  hc=normale(C,g(B,A))
  Call dbg  'Hc' rep(hc) hc
  HSP=sp(ha,hc)
  If HSP='?' Then
    HSP=sp(ha,hb)
  Say ''
  Say 'Orthocenter:' rep(HSP)

/***********************************************************************
* Perimeter and Area
***********************************************************************/
  Say ''
  Say 'Perimeter:' round(u(d))
  Say 'Area:     ' round(a(d))

/***********************************************************************
* Circumcircle
***********************************************************************/
  U=sp(ss(A,B),ss(B,C))
  Call dbg  'ss(A,B)='ss(A,B)
  Call dbg  'ss(B,c)='ss(B,c)
  Say ''
  Say 'Center of circumcircle    :' rep(U)
  Say 'Radius                    :' round(dist(U,A))

/***********************************************************************
* Inscribed circle
***********************************************************************/
  I=sp(wsa,wsb)
  Say ''
  Say 'Center of inscribed circle:' rep(I)
  Say 'Radius                    :' round(rho(d))

/***********************************************************************
* Centroid
***********************************************************************/
  Call dbg  MP(B,C)
  Call dbg  MP(C,A)
  sa=g(A,MP(B,C)); Call dbg  'sa='sa  rep(sa)
  sb=g(B,MP(C,A)); Call dbg  'sb='sb  rep(sb)
  S=sp(sa,sb)
  Say ''
  Say 'centroid:' rep(S)

/***********************************************************************
* Feuerbach Circle
***********************************************************************/
  MAB='P' (ax+bx)/2 (ay+by)/2
  MBC='P' (bx+cx)/2 (by+cy)/2
  MCA='P' (cx+ax)/2 (cy+ay)/2
  F=sp(ss(MAB,MBC),ss(MBC,MCA))
  Say ''
  Say 'Center of Feuerbach Circle:' rep(F)
  Say 'Radius                    :' round(dist(F,MAB))

/***********************************************************************
* Euler's Line  contains the following points:
* Centroid
* Center of circumcircle
* Orthocenter
* Center of Feuerbach Circle
***********************************************************************/
  Call dbg 'Centroid..................' rep(S)
  Call dbg 'Center of circumcircle....' rep(U)
  Call dbg 'Orthocenter...............' rep(HSP)
  Call dbg 'Center of Feuerbach Circle' rep(F)

  Say ''
  If abs(al-bl)<1.e-5 & abs(bl-cl)<1.e-5 Then
    Say 'Equilateral Triangle - no Eulersche Gerade'
  Else Do
    Say 'Euler''s Line:'
    su=rep(g(S,U));   Say 'S-U' su
    sh=rep(g(S,HSP)); Say 'S-H' sh
    sf=rep(g(S,F));   Say 'S-F' sf
    uh=rep(g(U,HSP)); Say 'U-H' uh
    End
  Exit

round: Procedure
  Numeric Digits 6
  Parse Arg z
  Return z+0

rep: Procedure Expose sigl
/***********************************************************************
* Show representation of a point or a line
***********************************************************************/
  Parse Arg type a
  Select
    When type='P' Then Do
      Parse Var a x y
      res='('||round(x)||'/'||round(y)||')'
      End
    When type='g' Then Do
      Parse Var a x1 y1 x2 y2
      Select
        When x1=x2 Then
          res='x='||round(x1)
        When y1=y2 Then
          res='y='round(y1)
        Otherwise Do
          k=(y2-y1)/(x2-x1)
          d=round(y1-k*x1)
          Select
            When d>0 Then d='+'d
            When d=0 Then d=''
            Otherwise Nop
            End
          If k=1 Then
            res='y=x'd
          Else
            res='y='round(k)'*x'd
          End
        End
      End
    Otherwise Do
      Say 'sigl='sigl
      Say 'Unsupported type' type
      res='???'
      End
    End
  Return res

a: Procedure
/***********************************************************************
* Area (Heron's formula)
***********************************************************************/
  Parse Arg . ax ay bx by cx cy .
  c=dist('P' ax ay,'P' bx by)
  a=dist('P' bx by,'P' cx cy)
  b=dist('P' cx cy,'P' ax ay)
  s=(a+b+c)/2
  res=rxCalcsqrt(s*(s-a)*(s-b)*(s-c))
  Return res

rho: Procedure Expose ax ay bx by cx cy
/***********************************************************************
* Radius of inscribed circle
***********************************************************************/
  Parse Arg . ax ay bx by cx cy .
  c=dist('P' ax ay,'P' bx by)
  a=dist('P' bx by,'P' cx cy)
  b=dist('P' cx cy,'P' ax ay)
  s=(a+b+c)/2
  res=rxCalcsqrt((s-a)*(s-b)*(s-c)/s)
  Return res

u: Procedure
/***********************************************************************
* Perimeter
***********************************************************************/
  Parse Arg . ax ay bx by cx cy .
  Return dist('P' ax ay,'P' bx by)+,
         dist('P' bx by,'P' cx cy)+,
         dist('P' cx cy,'P' ax ay)

dist: Procedure
/***********************************************************************
* Distance between two points
***********************************************************************/
  Parse Arg . x1 y1 . , . x2 y2 .
  Return rxCalcsqrt((x2-x1)**2+(y2-y1)**2)

g: Procedure
/***********************************************************************
* Intern representation of a line though two points
***********************************************************************/
  Parse Arg . x1 y1 . , . x2 y2 .
  Return 'g' x1 y1 (x1+(x2-x1)) (y1+(y2-y1))

MP: Procedure
/***********************************************************************
* Center of a line segment
***********************************************************************/
  Parse Arg . x1 y1 . , . x2 y2 .
  Return 'P' ((x1+x2)/2) ((y2+y1)/2)

sp: Procedure
/***********************************************************************
* Intersection of two lines
***********************************************************************/
  Parse Arg . xa ya xb yb . , . xc yc xd yd .
  z=(xc-xa)*(yd-yc) - (yc-ya)*(xd-xc)
  n=(xb-xa)*(yd-yc) - (yb-ya)*(xd-xc)
  If n=0 Then Do
    If z=0 Then
      Call dbg 'lines are identical' z'/'n xa ya xb yb xc yc xd yd
    Else
      Call dbg 'lines are paralllel' z'/'n xa ya xb yb xc yc xd yd
    Return '?'
    End
  Else Do
    t=z/n
    x=xa+(xb-xa)*t
    y=ya+(yb-ya)*t
    Call dbg x y
    Return 'P' x y
    End

euler: Procedure Expose S U HSP
/***********************************************************************
* Schwerpunkt, Umkreismittelpunkt, Höhenschnittpunkt
***********************************************************************/
Parse Arg . sx sy . ux uy . hx hy
Say 'Euler:' sx sy ux uy hx hy
eg=g(S,U);  Say rep(eg)
eg2=g(S,HSP);  Say rep(eg2)
eg3=g(U,HSP);  Say rep(eg3)
Return

dist2:Procedure
/***********************************************************************
* Distance of a point C from a line AB
***********************************************************************/
  Parse Arg ax ay bx by cx cy
  Say 'A('ax'/'ay')' 'B('bx'/'by')' 'C('cx'/'cy')'
  gx.1=ax
  gx.2=bx-ax
  gy.1=ay
  gy.2=by-ay

  Select
    When gx.2=0 & gy.2=0 Then
      Call ex 'g isn''t a line'
    When gx.2=0 Then Do
      xf=1
      yf=0
      c=-ax
      End
    When gy.2=0 Then Do
      xf=0
      yf=1
      c=-ay
      End
    Otherwise Do
      xf=1/gx.2
      yf=-1/gy.2
      c=-((ay/gy.2)+(ax/gx.2))
      End
    End
  call dbg xf'*x+'yf'*y-'c'=0'

  d=abs((xf*cx+yf*cy-c)/rxCalcsqrt(xf**2+yf**2))
  Call dbg 'd='d
  Return d

normale: Procedure
/***********************************************************************
* compute the line through point C that is normal to line A-B
***********************************************************************/
  Parse Arg . ax ay . , . bx by cx cy .
  vx=cx-bx
  vy=cy-by
  res='g' ax ay ax+vy ay-vx
  Call dbg  res
  Return res

ss: Procedure
/***********************************************************************
* compute the perpendicular bisector of a line segment
***********************************************************************/
  Parse Arg . ax ay . , . bx by .
  Call dbg 'A('ax'/'ay')' 'B('bx'/'by')'
  If ax=bx & ay=by Then
    Call ex 'AB isn''t a line segment'
  mx=(ax+bx)/2
  my=(ay+by)/2
  vx=bx-ax
  vy=by-ay
  Select
    When vx=0 Then Parse Value 1 0 With sx sy
    When vy=0 Then Parse Value 0 1 With sx sy
    Otherwise Do
      sx=vy
      sy=-vx
      End
    End
  Call dbg    'g' mx my (mx+sx) (my+sy)
  Return 'g' mx my (mx+sx) (my+sy)

ws: Procedure
/***********************************************************************
* compute the angular symmetric of point A
***********************************************************************/
  Parse Arg . ax ay . , . bx by . , . cx cy .
  ebl=rxCalcsqrt((bx-ax)**2+(by-ay)**2)
  ecl=rxCalcsqrt((cx-ax)**2+(cy-ay)**2)
--Say 'AB   ' (bx-ax)/ebl (by-ay)/ebl
--Say 'AC   ' (cx-ax)/ecl (cy-ay)/ecl
--Say 'AB+AC' ((bx-ax)/ebl+(cx-ax)/ecl) ((by-ay)/ebl+(cy-ay)/ecl)
  res='g' ax ay ax+((bx-ax)/ebl+(cx-ax)/ecl)*10,
                ay+((by-ay)/ebl+(cy-ay)/ecl)*10
  Return res

dbg:
  Return
  Say      arg(1)

ex:
  Say arg(1)
  Exit

::requires rxMath library
