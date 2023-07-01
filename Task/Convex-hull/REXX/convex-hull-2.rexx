/* REXX ---------------------------------------------------------------
* Compute the Convex Hull for a set of points
* Format of the input file:
* (16,3) (12,17) (0,6) (-4,-6) (16,6) (16,-7) (16,-3) (17,-4) (5,19)
* (19,-8) (3,16) (12,13) (3,-4) (17,5) (-3,15) (-3,-9) (0,11) (-9,-3)
* (-4,-2)
* Alternate (better) method using slopes
* 1) Compute path from lowest/leftmost to leftmost/lowest
* 2) Compute leftmost vertical border
* 3) Compute path from rightmost/highest to highest/rightmost
* 4) Compute path from highest/rightmost to rightmost/highest
* 5) Compute rightmost vertical border
* 6) Compute path from rightmost/lowest to lowest_leftmost point
*--------------------------------------------------------------------*/
Parse Arg fid
If fid='' Then Do
  fid='line.in'
  fid='point.in'
  fid='chullmin.in'                 /* miscellaneous test data       */
  fid='chullxx.in'
  fid='chullx.in'
  fid='chullt.in'
  fid='chulla.in'
  fid='sq.in'
  fid='tri.in'
  fid='z.in'
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
g.0xlist=''
Do i=1 To x.0                       /* loop over points              */
  x=x.i
  g.0xlist=g.0xlist x
  yl.x=sortv(yl.x)                  /* sort y-coordinates            */
  End
Call sho
If x.0<3 Then Do
  Say 'We need at least three points!'
  Exit
  End
Call o 'g.0xmin='g.0xmin
Call o 'g.0xmi ='g.0xmi
Call o 'g.0ymin='g.0ymin
Call o 'g.0ymi ='g.0ymi

Do i=1 To x.0
  x=x.i
  If minv(yl.x)=g.0ymin Then Leave
  End
lowest_leftmost=i

highest_rightmost=0
Do i=1 To x.0
  x=x.i
  If maxv(yl.x)=g.0ymax Then
    highest_rightmost=i
  If maxv(yl.x)<g.0ymax Then
    If highest_rightmost>0 Then
      Leave
  End
Call o 'lowest_leftmost='lowest_leftmost
Call o 'highest_rightmost  ='highest_rightmost

x=x.lowest_leftmost
Call o 'We start at' from x'/'minv(yl.x)
path=x'/'minv(yl.x)
/*---------------------------------------------------------------------
* 1) Compute path from lowest/leftmost to leftmost/lowest
*--------------------------------------------------------------------*/
Call min_path lowest_leftmost,1
/*---------------------------------------------------------------------
* 2) Compute leftmost vertical border
*--------------------------------------------------------------------*/
Do i=2 To words(yl.x)
  path=path x'/'word(yl.x,i)
  End
cxy=x'/'maxv(yl.x)
/*---------------------------------------------------------------------
* 3) Compute path from rightmost/highest to highest/rightmost
*--------------------------------------------------------------------*/
Call max_path ci,highest_rightmost
/*---------------------------------------------------------------------
* 4) Compute path from highest/rightmost to rightmost/highest
*--------------------------------------------------------------------*/
Call max_path ci,x.0
/*---------------------------------------------------------------------
* 5) Compute rightmost vertical border
*--------------------------------------------------------------------*/
Do i=words(yl.x)-1 To 1 By -1
  cxy=x'/'word(yl.x,i)
  path=path cxy
  End
/*---------------------------------------------------------------------
* 6) Compute path from rightmost/lowest to lowest_leftmost
*--------------------------------------------------------------------*/
Call min_path ci,lowest_leftmost

Parse Var path pathx path
have.=0
Do i=1 By 1 While path>''
  Parse Var path xy path
  If have.xy=0 Then Do
    pathx=pathx xy
    have.xy=1
    End
  End
Say 'Points of convex hull in clockwise order:'
Say pathx
Call lineout g.0oid
Exit

min_path:
  Parse Arg from,tgt
  ci=from
  cxy=x.ci
  Do Until ci=tgt
    kmax=-1000
    Do i=ci-1 To 1 By sign(tgt-from)
      x=x.i
      k=k(cxy'/'minv(yl.cxy),x'/'minv(yl.x))
      If k>kmax Then Do
        kmax=k
        ii=i
        End
      End
    ci=ii
    cxy=x.ii
    path=path cxy'/'minv(yl.cxy)
    End
  Return

max_path:
  Parse Arg from,tgt
  Do Until ci=tgt
    kmax=-1000
    Do i=ci+1 To tgt
      x=x.i
      k=k(cxy,x'/'maxv(yl.x))
      If k>kmax Then Do
        kmax=k
        ii=i
        End
      End
    x=x.ii
    cxy=x'/'maxv(yl.x)
    path=path cxy
    ci=ii
    End
  Return

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

k: Procedure
/*---------------------------------------------------------------------
* Compute slope of a straight line
* that is defined by two points:  y=k*x+d
* Specialty; k='*' x=xa if xb=xa
*--------------------------------------------------------------------*/
  Call trace 'O'
  Parse Arg xya,xyb
  Parse Var xya xa '/' ya
  Parse Var xyb xb '/' yb
  If xa=xb Then
    k='*'
  Else
    k=(yb-ya)/(xb-xa)
  Return k

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
