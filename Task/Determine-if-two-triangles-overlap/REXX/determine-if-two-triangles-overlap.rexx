/* REXX */
Signal On Halt
Signal On Novalue
Signal On Syntax

fid='trio.in'
oid='trio.txt'; 'erase' oid


Call trio_test '0 0   5 0   0 5   0 0   5  0   0 6'
Call trio_test '0 0   0 5   5 0   0 0   0  5   5 0'
Call trio_test '0 0   5 0   0 5 -10 0  -5  0  -1 6'
Call trio_test '0 0   5 0 2.5 5   0 4 2.5 -1   5 4'
Call trio_test '0 0   1 1   0 2   2 1   3  0   3 2'
Call trio_test '0 0   1 1   0 2   2 1   3 -2   3 4'
Call trio_test '0 0   1 0   0 1   1 0   2  0   1 1'

Call trio_test '1 0   3 0   2 2   1 3   3  3   2 5'
Call trio_test '1 0   3 0   2 2   1 3   3  3   2 2'
Call trio_test '0 0   2 0   2 2   3 3   5  3   5 5'
Call trio_test '2 0   2 6   1 8   0 1   0  5   8 3'
Call trio_test '0 0   4 0   0 4   0 2   2  0   2 2'
Call trio_test '0 0   4 0   0 4   1 1   2  1   1 2'
Exit

trio_test:
parse Arg tlist
tlist=space(tlist)
Parse Arg ax ay bx by cx cy dx dy ex ey fx fy

Say 'ABC:' show_p(ax ay) show_p(bx by) show_p(cx cy)
Say 'DEF:' show_p(dx dy) show_p(ex ey) show_p(fx fy)

bordl=bord(tlist)  /* corners that are on the other triangle's edges */
If bordl<>'' Then
  Say 'Corners on the other triangle''s edges:' bordl
wb=words(bordl)                     /* how many of them?             */
Select
  When wb=3 Then Do                 /* all three match               */
    If ident(ax ay,bx by,cx cy,dx dy,ex ey,fx fy) Then
      Say 'Triangles are identical'
    Else
      Say 'Triangles overlap'
    Say ''
    Return
    End
  When wb=2 Then Do                 /* two of them match             */
    Say 'Triangles overlap'
    Say '  they have a common edge 'bordl
    Say ''
    Return
    End
  When wb=1 Then Do                 /* one of them match             */
    Say 'Triangles touch on' bordl  /* other parts may overlap       */
    Say '  we analyze further'
    End
  Otherwise                         /* we know nothing yet           */
    Nop
  End

trio_result=trio(tlist)             /* any other overlap?            */

Select
  When trio_result=0 Then Do        /* none whatsoever               */
    If wb=1 Then
      Say 'Triangles touch (border case) at' show_p(bordl)
    Else
      Say 'Triangles don''t overlap'
    End
  When trio_result>0 Then           /* plain overlapping case        */
    Say 'Triangles overlap'
  End
Say ''
Return

trio:
/*---------------------------------------------------------------------
* Determine if two triangles overlap
*--------------------------------------------------------------------*/
parse Arg tlist
Parse Arg pax pay pbx pby pcx pcy pdx pdy pex pey pfx pfy

abc=subword(tlist,1,6)
def=subword(tlist,7,6)

Do i=1 To 3
  s.i=subword(abc abc,i*2-1,4)
  t.i=subword(def def,i*2-1,4)
  End

abc_=''
def_=''

Do i=1 To 3
  abc.i=subword(abc,i*2-1,2)   /* corners of ABC */
  def.i=subword(def,i*2-1,2)   /* corners of DEF */
  Parse Var abc.i x y; abc_=abc_ '('||x','y')'
  Parse Var def.i x y; def_=def_ '('||x','y')'
  End
Call o 'abc_='abc_
Call o 'def_='def_

over=0
  Do i=1 To 3 Until over
    Do j=1 To 3 Until over
      If ssx(s.i t.j) Then Do       /* intersection of two edges     */
        over=1
        Leave
        End
      End
    End

If over=0 Then Do                   /* no edge intersection found    */
  Do ii=1 To 3 Until over           /* look for first possibility    */
    Call o '    '  'abc.'ii'='abc.ii 'def='def
    Call o 'ii='ii 'def.'ii'='def.ii 'abc='abc
    If in_tri(abc.ii,def) Then Do   /* a corner of ABC is in DEF     */
      Say abc.ii 'is within' def
      over=1
      End
    Else If in_tri(def.ii,abc) Then Do  /* a corner of DEF is in ABC */
      Say def.ii 'is within' abc
      over=1
      End
    End
  End

If over=0 Then rw='don''t '
Else rw=''

Call o 'Triangles' show_p(pax pay) show_p(pbx pby) show_p(pcx pcy),
             'and' show_p(pdx pdy) show_p(pex pey) show_p(pfx pfy),
                                                            rw'overlap'
Call o ''
Return over

ssx: Procedure Expose oid bordl
/*---------------------------------------------------------------------
* Intersection of 2 line segments A-B and C-D
*--------------------------------------------------------------------*/
Parse Arg xa ya xb yb xc yc xd yd

d=ggx(xa ya xb yb xc yc xd yd)

Call o 'ssx:' arg(1) d
res=0
Select
  When d='-' Then res=0
  When d='I' Then Do
    If xa<>xb Then Do
      xab_min=min(xa,xb)
      xcd_min=min(xc,xd)
      xab_max=max(xa,xb)
      xcd_max=max(xc,xd)
      If xab_min>xcd_max |,
         xcd_min>xab_max Then
        res=0
      Else Do
        res=1
        Select
          When xa=xc & isb(xc,xb,xd)=0 Then Do; x=xa; y=ya; End
          When xb=xc & isb(xc,xa,xd)=0 Then Do; x=xb; y=yb; End
          When xa=xd & isb(xc,xb,xd)=0 Then Do; x=xa; y=ya; End
          When xb=xd & isb(xc,xa,xd)=0 Then Do; x=xb; y=yb; End
          Otherwise Do
            x='*'
            y=ya
            End
          End
        Call o  'ssx:' x y
        End
      End
    Else Do
      yab_min=min(ya,yb)
      ycd_min=min(yc,yd)
      yab_max=max(ya,yb)
      ycd_max=max(yc,yd)
      If yab_min>ycd_max |,
         ycd_min>yab_max Then
        res=0
      Else Do
        res=1
        x=xa
        y='*'
        Parse Var bordl x_bord '/' y_bord
        If x=x_bord Then Do
          Call o  xa'/* IGNORED'
          res=0
          End
        End
      End
    End
  Otherwise Do
    Parse Var d x y
    If is_between(xa,x,xb) &,
       is_between(xc,x,xd) &,
       is_between(ya,y,yb) &,
       is_between(yc,y,yd) Then Do
      If x'/'y<>bordl Then
        res=1
      End
    End
  End
  If res=1 Then Do
    Say 'Intersection of line segments: ('||x'/'y')'
    Parse Var bordl x_bord '/' y_bord
    If x=x_bord Then Do
      res=0
      Call o x'/'y 'IGNORED'
      End
    End
  Else Call o  'ssx: -'
Return res

ggx: Procedure Expose oid bordl
/*---------------------------------------------------------------------
* Intersection of 2 (straight) lines
*--------------------------------------------------------------------*/
Parse Arg xa ya xb yb xc yc xd yd
res=''
If xa=xb Then Do
  k1='*'
  x1=xa
  If ya=yb Then Do
    res='Points A and B are identical'
    rs='*'
    End
  End
Else Do
  k1=(yb-ya)/(xb-xa)
  d1=ya-k1*xa
  End
If xc=xd Then Do
  k2='*'
  x2=xc
  If yc=yd Then Do
    res='Points C and D are identical'
    rs='*'
    End
  End
Else Do
  k2=(yd-yc)/(xd-xc)
  d2=yc-k2*xc
  End

If res='' Then Do
  If k1='*' Then Do
    If k2='*' Then Do
      If x1=x2 Then Do
        res='Lines AB and CD are identical'
        rs='I'
        End
      Else Do
        res='Lines AB and CD are parallel'
        rs='-'
        End
      End
    Else Do
      x=x1
      y=k2*x+d2
      End
    End
  Else Do
    If k2='*' Then Do
      x=x2
      y=k1*x+d1
      End
    Else Do
      If k1=k2 Then Do
        If d1=d2 Then Do
          res='Lines AB and CD are identical'
          rs='I'
          End
        Else Do
          res='Lines AB and CD are parallel'
          rs='-'
          End
        End
      Else Do
        x=(d2-d1)/(k1-k2)
        y=k1*x+d1
        End
      End
    End
  End
  If res='' Then Do
    res='Intersection is ('||x'/'y')'
    rs=x y
    Call o 'line intersection' x y
    End
  Call o 'A=('xa'/'ya') B=('||xb'/'yb') C=('||xc'/'yc') D=('||xd'/'yd')' '-->' res
  Return rs

isb: Procedure
  Parse Arg a,b,c
  Return sign(b-a)<>sign(b-c)

is_between: Procedure Expose oid
  Parse Arg a,b,c
  Return diff_sign(b-a,b-c)

diff_sign: Procedure
  Parse Arg diff1,diff2
  Return (sign(diff1)<>sign(diff2))|(sign(diff1)=0)

o:
/*y 'sigl='sigl */
Return lineout(oid,arg(1))

in_tri: Procedure Expose oid bordl
/*---------------------------------------------------------------------
* Determine if the point (px/py) is within the given triangle
*--------------------------------------------------------------------*/
Parse Arg px py,ax ay bx by cx cy
abc=ax ay bx by cx cy
res=0
maxx=max(ax,bx,cx)
minx=min(ax,bx,cx)
maxy=max(ay,by,cy)
miny=min(ay,by,cy)

If px>maxx|px<minx|py>maxy|py<miny Then
  Return 0

Parse Value mk_g(ax ay,bx by) With k.1 d.1 x.1
Parse Value mk_g(bx by,cx cy) With k.2 d.2 x.2
Parse Value mk_g(cx cy,ax ay) With k.3 d.3 x.3
/*
say 'g1:' show_g(k.1,d.1,x.1)
say 'g2:' show_g(k.2,d.2,x.2)
say 'g3:' show_g(k.3,d.3,x.3)
Say px py '-' ax ay bx by cx cy
*/
Do i=1 To 3
  Select
    When k.i='*' Then
      Call o 'g.'i':' 'x='||x.i
    When k.i=0 Then
      Call o 'g.'i':' 'y='d.i
    Otherwise
      Call o 'g.'i':' 'y=' k.i'*x'dd(d.i)
    End
  End

If k.1='*' Then Do
  y2=k.2*px+d.2
  y3=k.3*px+d.3
  If is_between(y2,py,y3) Then
    res=1
  End
Else Do
  kp1=k.1
  dp1=py-kp1*px
  If k.2='*' Then
    x12=x.2
  Else
    x12=(d.2-dp1)/(kp1-k.2)
  If k.3='*' Then
    x13=x.3
  Else
    x13=(d.3-dp1)/(kp1-k.3)
  If is_between(x12,px,x13) Then
    res=1
  End

If res=1 Then rr=' '
         Else rr=' not '
If pos(px'/'py,bordl)>0 Then Do
  ignored=' but is IGNORED'
  res=0
  End
Else
  ignored=''
Say 'P ('px','py') is'rr'in' abc  ignored
Return res

bord:
/*---------------------------------------------------------------------
* Look for corners of triangles that are situated
* on the edges of the other triangle
*--------------------------------------------------------------------*/
parse Arg tlist
Parse Arg pax pay pbx pby pcx pcy pdx pdy pex pey pfx pfy
bordl=''
abc=subword(tlist,1,6)
def=subword(tlist,7,6)

Do i=1 To 3
  s.i=subword(abc abc,i*2-1,4)
  t.i=subword(def def,i*2-1,4)
  End

abc_=''
def_=''
Do i=1 To 3
  abc.i=subword(abc,i*2-1,2)
  def.i=subword(def,i*2-1,2)
  Parse Var abc.i x y; abc_=abc_ '('||x','y')'
  Parse Var def.i x y; def_=def_ '('||x','y')'
  End

Do i=1 To 3
  i1=i+1
  If i1=4 Then i1=1
  Parse Value mk_g(abc.i,abc.i1) With k.1.i d.1.i x.1.i
  Parse Value mk_g(def.i,def.i1) With k.2.i d.2.i x.2.i
  End
Do i=1 To 3
  Call o  show_g(k.1.i,d.1.i,x.1.i)
  End
Do i=1 To 3
  Call o  show_g(k.2.i,d.2.i,x.2.i)
  End

pl=''
Do i=1 To 3
  p=def.i
  Do j=1 To 3
    j1=j+1
    If j1=4 Then j1=1
    g='1.'j
    If in_segment(p,abc.j,abc.j1) Then Do
      pp=Translate(p,'/',' ')
      If wordpos(pp,bordl)=0 Then
        bordl=bordl pp
      End
    Call o  show_p(p) show_g(k.g,d.g,x.g) '->' bordl
    End
  End
Call o  'Points on abc:' pl

pl=''
Do i=1 To 3
  p=abc.i
  Do j=1 To 3
    j1=j+1
    If j1=4 Then j1=1
    g='2.'j
    If in_segment(p,def.j,def.j1)Then Do
      pp=Translate(p,'/',' ')
      If wordpos(pp,bordl)=0 Then
        bordl=bordl pp
      End
    Call o  show_p(p) show_g(k.g,d.g,x.g) '->' bordl
    End
  End
Call o  'Points on def:' pl

Return bordl

in_segment: Procedure Expose g. sigl
/*---------------------------------------------------------------------
* Determine if point x/y is on the line segment ax/ay bx/by
*--------------------------------------------------------------------*/
Parse Arg x y,ax ay,bx by
Call show_p(x y) show_p(ax ay) show_p(bx by)
Parse Value mk_g(ax ay,bx by) With gk gd gx
Select
  When gx<>'' Then
    res=(x=gx & is_between(ay,y,by))
  When gk='*' Then
    res=(y=gd & is_between(ax,x,bx))
  Otherwise Do
    yy=gk*x+gd
    res=(y=yy & is_between(ax,x,bx))
    End
  End
Return res

mk_g: Procedure Expose g.
/*---------------------------------------------------------------------
* given two points (a and b)
* compute y=k*x+d or, if a vertical line, k='*'; x=c
*--------------------------------------------------------------------*/
Parse Arg a,b                       /* 2 points                      */
Parse Var a ax ay
Parse Var b bx by
If ax=bx Then Do                    /* vertical line                 */
  gk='*'                            /* special slope                 */
  gx=ax                             /* x=ax is  the equation         */
  gd='*'                            /* not required                  */
  End
Else Do
  gk=(by-ay)/(bx-ax)                /* compute slope                 */
  gd=ay-gk*ax                       /* compute y-distance            */
  gx=''                             /* not required                  */
  End
Return gk gd gx

is_between: Procedure
  Parse Arg a,b,c
  Return diff_sign(b-a,b-c)

diff_sign: Procedure
  Parse Arg diff1,diff2
  Return (sign(diff1)<>sign(diff2))|(sign(diff1)=0)

show_p: Procedure
  Call trace 'O'
  Parse Arg x y
  If pos('/',x)>0 Then
    Parse Var x x '/' y
  Return space('('||x'/'y')',0)

isb: Procedure Expose oid
  Parse Arg a,b,c
  Return sign(b-a)<>sign(b-c)

o: Call o  arg(1)
   Return

show_g: Procedure
/*---------------------------------------------------------------------
* given slope, y-distance, and (special) x-value
* compute y=k*x+d or, if a vertical line, k='*'; x=c
*--------------------------------------------------------------------*/
Parse Arg k,d,x
Select
  When k='*' Then res='x='||x       /* vertical line                 */
  When k=0   Then res='y='d         /* horizontal line               */
  Otherwise Do                      /* ordinary line                 */
    Select
      When k=1  Then res='y=x'dd(d)
      When k=-1 Then res='y=-x'dd(d)
      Otherwise      res='y='k'*x'dd(d)
      End
    End
  End
Return res

dd: Procedure
/*---------------------------------------------------------------------
* prepare y-distance for display
*--------------------------------------------------------------------*/
  Parse Arg dd
  Select
    When dd=0 Then dd=''            /* omit dd if it's zero          */
    When dd<0 Then dd=dd            /* use dd as is (-value)         */
    Otherwise      dd='+'dd         /* prepend '+' to positive dd    */
    End
  Return dd

ident: Procedure
/*---------------------------------------------------------------------
* Determine if the corners ABC match those of DEF (in any order)
*--------------------------------------------------------------------*/
  cnt.=0
  Do i=1 To 6
    Parse Value Arg(i) With x y
    cnt.x.y=cnt.x.y+1
    End
  Do i=1 To 3
    Parse Value Arg(i) With x y
    If cnt.x.y<>2 Then
      Return 0
    End
  Return 1

Novalue:
  Say  'Novalue raised in line' sigl
  Say  sourceline(sigl)
  Say  'Variable' condition('D')
  Signal lookaround

Syntax:
  Say  'Syntax raised in line' sigl
  Say  sourceline(sigl)
  Say  'rc='rc '('errortext(rc)')'

halt:
lookaround:
  If fore() Then Do
    Say  'You can look around now.'
    Trace ?R
    Nop
    End
  Exit 12
