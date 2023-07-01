/* REXX ---------------------------------------------------------------
* Compute the Convex Hull for a set of points
* Format of the input file:
* (16,3) (12,17) (0,6) (-4,-6) (16,6) (16,-7) (16,-3) (17,-4) (5,19)
* (19,-8) (3,16) (12,13) (3,-4) (17,5) (-3,15) (-3,-9) (0,11) (-9,-3)
* (-4,-2)
*--------------------------------------------------------------------*/
  Signal On Novalue
  Signal On Syntax
Parse Arg fid
If fid='' Then Do
  fid='chullmin.in'                 /* miscellaneous test data       */
  fid='chullx.in'
  fid='chullt.in'
  fid='chulla.in'
  fid='chullxx.in'
  fid='sq.in'
  fid='tri.in'
  fid='line.in'
  fid='point.in'
  fid='chull.in'                    /* data from task description    */
  End
g.0debug=''
g.0oid=fn(fid)'.txt'; 'erase' g.0oid
x.=0
yl.=''
Parse Value '1000 -1000' With g.0xmin g.0xmax
Parse Value '1000 -1000' With g.0ymin g.0ymax
/*---------------------------------------------------------------------
* First read the input and store the points' coordinates
* x.0 contains the number of points, x.i contains the x.coordinate
* yl.x contains the y.coordinate(s) of points (x/y)
*--------------------------------------------------------------------*/
Do while lines(fid)>0
  l=linein(fid)
  Do While l<>''
    Parse Var l '(' x ',' y ')' l
    Call store x,y
    End
  End
Call lineout fid
Do i=1 To x.0                       /* loop over points              */
  x=x.i
  yl.x=sortv(yl.x)                  /* sort y-coordinates            */
  End
Call sho

/*---------------------------------------------------------------------
* Now we look for special border points:
* lefthigh and leftlow: leftmost points with higheste and lowest y
* ritehigh and ritelow: rightmost points with higheste and lowest y
* yl.x contains the y.coordinate(s) of points (x/y)
*--------------------------------------------------------------------*/
leftlow=0
lefthigh=0
Do i=1 To x.0
  x=x.i
  If maxv(yl.x)=g.0ymax Then Do
    If lefthigh=0 Then lefthigh=x'/'g.0ymax
    ritehigh=x'/'g.0ymax
    End
  If minv(yl.x)=g.0ymin Then Do
    ritelow=x'/'g.0ymin
    If leftlow=0 Then leftlow=x'/'g.0ymin
    End
  End
Call o 'lefthigh='lefthigh
Call o 'ritehigh='ritehigh
Call o 'ritelow ='ritelow
Call o 'leftlow ='leftlow
/*---------------------------------------------------------------------
* Now we look for special border points:
* leftmost_n and leftmost_s: points with lowest x and highest/lowest y
* ritemost_n and ritemost_s: points with largest x and highest/lowest y
* n and s stand foNorth and South, respectively
*--------------------------------------------------------------------*/
x=g.0xmi; leftmost_n=x'/'maxv(yl.x)
x=g.0xmi; leftmost_s=x'/'minv(yl.x)
x=g.0xma; ritemost_n=x'/'maxv(yl.x)
x=g.0xma; ritemost_s=x'/'minv(yl.x)

/*---------------------------------------------------------------------
* Now we compute the paths from ritehigh to ritelow (n_end)
* and leftlow to lefthigh (s_end), respectively
*--------------------------------------------------------------------*/
x=g.0xma
n_end=''
Do i=words(yl.x) To 1 By -1
  n_end=n_end x'/'word(yl.x,i)
  End
Call o 'n_end='n_end
x=g.0xmi
s_end=''
Do i=1 To words(yl.x)
  s_end=s_end x'/'word(yl.x,i)
  End
Call o 's_end='s_end

n_high=''
s_low=''
/*---------------------------------------------------------------------
* Now we compute the upper part of the convex hull (nhull)
*--------------------------------------------------------------------*/
Call o 'leftmost_n='leftmost_n
Call o 'lefthigh  ='lefthigh
nhull=leftmost_n
res=mk_nhull(leftmost_n,lefthigh);
nhull=nhull res
Call o 'A nhull='nhull
Do While res<>lefthigh
  res=mk_nhull(res,lefthigh); nhull=nhull res
  Call o 'B nhull='nhull
  End
res=mk_nhull(lefthigh,ritemost_n); nhull=nhull res
Call o 'C nhull='nhull
Do While res<>ritemost_n
  res=mk_nhull(res,ritemost_n); nhull=nhull res
  Call o 'D nhull='nhull
  End

nhull=nhull n_end                /* attach the right vertical border */

/*---------------------------------------------------------------------
* Now we compute the lower part of the convex hull (shull)
*--------------------------------------------------------------------*/
res=mk_shull(ritemost_s,ritelow);
shull=ritemost_s res
Call o 'A shull='shull
Do While res<>ritelow
  res=mk_shull(res,ritelow)
  shull=shull res
  Call o 'B shull='shull
  End
res=mk_shull(ritelow,leftmost_s)
shull=shull res
Call o 'C shull='shull
Do While res<>leftmost_s
  res=mk_shull(res,leftmost_s);
  shull=shull res
  Call o 'D shull='shull
  End

shull=shull s_end

chull=nhull shull                 /* concatenate upper and lower part */
                                  /* eliminate duplicates             */
                                  /* too lazy to take care before :-) */
Parse Var chull chullx chull
have.=0
have.chullx=1
Do i=1 By 1 While chull>''
  Parse Var chull xy chull
  If have.xy=0 Then Do
    chullx=chullx xy
    have.xy=1
    End
  End
                                   /* show the result                */
Say 'Points of convex hull in clockwise order:'
Say    chullx
/**********************************************************************
* steps that were necessary in previous attempts
/*---------------------------------------------------------------------
* Final polish: Insert points that are not yet in chullx but should be
* First on the upper hull going from left to right
*--------------------------------------------------------------------*/
i=1
Do While i<words(chullx)
  xya=word(chullx,i)  ; Parse Var xya xa '/' ya
  If xa=g.0xmax Then Leave
  xyb=word(chullx,i+1); Parse Var xyb xb '/' yb
  Do j=1 To x.0
    If x.j>xa Then Do
      If x.j<xb Then Do
        xx=x.j
        parse Value kdx(xya,xyb) With k d x
        If (k*xx+d)=maxv(yl.xx) Then Do
          chullx=subword(chullx,1,i) xx'/'maxv(yl.xx),
                                                    subword(chullx,i+1)
          i=i+1
          End
        End
      End
    Else
      i=i+1
    End
  End

Say    chullx

/*---------------------------------------------------------------------
* Final polish: Insert points that are not yet in chullx but should be
* Then on the lower hull going from right to left
*--------------------------------------------------------------------*/
i=wordpos(ritemost_s,chullx)
Do While i<words(chullx)
  xya=word(chullx,i)  ; Parse Var xya xa '/' ya
  If xa=g.0xmin Then Leave
  xyb=word(chullx,i+1); Parse Var xyb xb '/' yb
  Do j=x.0 To 1 By -1
    If x.j<xa Then Do
      If x.j>xb Then Do
        xx=x.j
        parse Value kdx(xya,xyb) With k d x
        If (k*xx+d)=minv(yl.xx) Then Do
          chullx=subword(chullx,1,i) xx'/'minv(yl.xx),
                                                    subword(chullx,i+1)
          i=i+1
          End
        End
      End
    Else
      i=i+1
    End
  End
Say chullx
**********************************************************************/
Call lineout g.0oid

Exit

store: Procedure Expose x. yl. g.
/*---------------------------------------------------------------------
* arrange the points in ascending order of x (in x.) and,
* for each x in ascending order of y (in yl.x)
* g.0xmin is the smallest x-value, etc.
* g.0xmi  is the x-coordinate
* g.0ymin is the smallest y-value, etc.
* g.0ymi  is the x-coordinate of such a point
*--------------------------------------------------------------------*/
  Parse Arg x,y
  Call o 'store' x y
  If x<g.0xmin Then Do; g.0xmin=x; g.0xmi=x; End
  If x>g.0xmax Then Do; g.0xmax=x; g.0xma=x; End
  If y<g.0ymin Then Do; g.0ymin=y; g.0ymi=x; End
  If y>g.0ymax Then Do; g.0ymax=y; g.0yma=x; End
  Do i=1 To x.0
    Select
      When x.i>x Then
        Leave
      When x.i=x Then Do
        yl.x=yl.x y
        Return
        End
      Otherwise
        Nop
      End
    End
  Do j=x.0 To i By -1
    ja=j+1
    x.ja=x.j
    End
  x.i=x
  yl.x=y
  x.0=x.0+1
  Return

sho: Procedure Expose x. yl. g.
  Do i=1 To x.0
    x=x.i
    say  format(i,2) 'x='format(x,3) 'yl='yl.x
    End
  Say ''
  Return

maxv: Procedure Expose g.
  Call trace 'O'
  Parse Arg l
  res=-1000
  Do While l<>''
    Parse Var l v l
    If v>res Then res=v
    End
  Return res

minv: Procedure Expose g.
  Call trace 'O'
  Parse Arg l
  res=1000
  Do While l<>''
    Parse Var l v l
    If v<res Then res=v
    End
  Return res

sortv: Procedure Expose g.
  Call trace 'O'
  Parse Arg l
  res=''
  Do Until l=''
    v=minv(l)
    res=res v
    l=remove(v,l)
    End
  Return space(res)

lastword: return word(arg(1),words(arg(1)))

kdx: Procedure  Expose xy. g.
/*---------------------------------------------------------------------
* Compute slope and y-displacement of a straight line
* that is defined by two points:  y=k*x+d
* Specialty; k='*' x=xa if xb=xa
*--------------------------------------------------------------------*/
  Call trace 'O'
  Parse Arg xya,xyb
  Parse Var xya xa '/' ya
  Parse Var xyb xb '/' yb
  If xa=xb Then
    Parse Value '*' '-' xa With k d x
  Else Do
    k=(yb-ya)/(xb-xa)
    d=yb-k*xb
    x='*'
    End
  Return k d x

remove:
/*---------------------------------------------------------------------
* Remove a specified element (e) from a given string (s)
*--------------------------------------------------------------------*/
  Parse Arg e,s
  Parse Var s sa (e) sb
  Return space(sa sb)

o: Procedure Expose g.
/*---------------------------------------------------------------------
* Write a line to the debug file
*--------------------------------------------------------------------*/
  If arg(2)=1 Then say arg(1)
  Return lineout(g.0oid,arg(1))

is_ok: Procedure Expose x. yl. g. sigl
/*---------------------------------------------------------------------
* Test if a given point (b) is above/on/or below a straight line
* defined by two points (a and c)
*--------------------------------------------------------------------*/
  Parse Arg a,b,c,op
  Call o    'is_ok' a b c op
  Parse Value kdx(a,c) With k d x
  Parse Var b x'/'y
  If op='U' Then y=maxv(yl.x)
            Else y=minv(yl.x)
  Call o    y x (k*x+d)
  If (abs(y-(k*x+d))<1.e-8) Then Return 0
  If op='U' Then res=(y<=(k*x+d))
            Else res=(y>=(k*x+d))
  Return res

mk_nhull: Procedure Expose x. yl. g.
/*---------------------------------------------------------------------
* Compute the upper (north) hull between two points (xya and xyb)
* Move x from xyb back to xya until all points within the current
* range (x and xyb) are BELOW the straight line defined xya and x
* Then make x the new starting point
*--------------------------------------------------------------------*/
  Parse Arg xya,xyb
  Call o 'mk_nhull' xya xyb
  If xya=xyb Then Return xya
  Parse Var xya xa '/' ya
  Parse Var xyb xb '/' yb
  iu=0
  iv=0
  Do xi=1 To x.0
    if x.xi>=xa & iu=0 Then iu=xi
    if x.xi<=xb Then iv=xi
    If x.xi>xb Then Leave
    End
  Call o    iu iv
  xu=x.iu
  xyu=xu'/'maxv(yl.xu)
  Do h=iv To iu+1 By -1 Until good
    Call o 'iv='iv,g.0debug
    Call o ' h='h,g.0debug
    xh=x.h
    xyh=xh'/'maxv(yl.xh)
    Call o    'Testing' xyu xyh,g.0debug
    good=1
    Do hh=h-1 To iu+1 By -1 While good
      xhh=x.hh
      xyhh=xhh'/'maxv(yl.xhh)
      Call o 'iu hh iv=' iu hh h,g.0debug
      If is_ok(xyu,xyhh,xyh,'U') Then Do
        Call o    xyhh 'is under' xyu xyh,g.0debug
        Nop
        End
      Else Do
        good=0
        Call o    xyhh 'is above' xyu xyh '-' xyh 'ist nicht gut'
        End
      End
    End
  Call o xyh 'is the one'

  Return xyh

p: Return
Say arg(1)
Pull  .
Return

mk_shull: Procedure Expose x. yl. g.
/*---------------------------------------------------------------------
* Compute the lower (south) hull between two points (xya and xyb)
* Move x from xyb back to xya until all points within the current
* range (x and xyb) are ABOVE the straight line defined xya and x
* Then make x the new starting point
*-----
---------------------------------------------------------------*/
  Parse Arg xya,xyb
  Call o 'mk_shull' xya xyb
  If xya=xyb Then Return xya
  Parse Var xya xa '/' ya
  Parse Var xyb xb '/' yb
  iu=0
  iv=0
  Do xi=x.0 To 1 By -1
    if x.xi<=xa & iu=0 Then iu=xi
    if x.xi>=xb Then iv=xi
    If x.xi<xb Then Leave
    End
  Call o iu iv '_' x.iu x.iv
  Call o 'mk_shull iv iu' iv iu
  xu=x.iu
  xyu=xu'/'minv(yl.xu)
  good=0
  Do h=iv To iu-1 Until good
    xh=x.h
    xyh=xh'/'minv(yl.xh)
    Call o    'Testing' xyu xyh   h iu
    good=1
    Do hh=h+1 To iu-1 While good
      Call o 'iu hh h=' iu hh h
      xhh=x.hh
      xyhh=xhh'/'minv(yl.xhh)
      If is_ok(xyu,xyhh,xyh,'O') Then Do
        Call o xyhh 'is above' xyu xyh
        Nop
        End
      Else Do
        Call o xyhh 'is under' xyu xyh '-' xyh 'ist nicht gut'
        good=0
        End
      End
    End
  Call o xyh 'is the one'
  Return xyh

Novalue:
  Say 'Novalue raised in line' sigl
  Say sourceline(sigl)
  Say 'Variable' condition('D')
  Signal lookaround

Syntax:
  Say 'Syntax raised in line' sigl
  Say sourceline(sigl)
  Say 'rc='rc '('errortext(rc)')'

halt:
lookaround:
  Say 'You can look around now.'
  Trace ?R
  Nop
  Exit 12
