/* REXX ---------------------------------------------------------------
* 19.06.2014 Walter Pachl alternate algorithm
* the idea: yl is a list of y coordinates which may have unused points
* one of the y's is picked at random
* Then we look for unused x coordinates in this line
* we pick one at random or drop the y from yl if none is found
* When yl becomes empty, all points are used and we stop
*--------------------------------------------------------------------*/
Parse Arg n r rr scale
If r=''     Then r=10
If rr=''    Then rr=15
If n=''     Then n=100
If scale='' Then scale=2
r2=r*r
rr2=rr*rr
ymin=0
ymax=rr*2
ol=''
pp.=0
used.=0
yl=''                                  /* list of available y values */
Do y=-rr To rr
  yl=yl y
  End
Do Until pp.0=n                        /*look for the required points*/
  If yl='' Then Do                     /* no more points available   */
    Say 'all points filled'
    Leave
    End
  yi=random(1,words(yl))               /* pick a y                   */
  y=word(yl,yi)
  y2=y*y
  p.=0
  Do x=0 To rr                         /* Loop through possible x's  */
    x2=x*x
    xy2=x2+y2
    If xy2>=r2&xy2<=rr2 Then Do        /* within the annulus         */
      Call take x y
      Call take (-x) y
      End
    End
  If p.0>0 Then Do                     /* some x's found (or just 1) */
    xi=random(1,p.0)                   /* pick an x                  */
    z=pp.0+1
    pp.z=p.xi
    pp.0=z
    Parse Var pp.z xa ya
    used.xa.ya=1                       /* remember it's taken        */
    End
  Else Do                              /* no x for this y            */
    yi=wordpos(y,yl)                   /* remove y from yl           */
    Select
      When yi=1 Then yl=subword(yl,yi+1)
      When yi=words(yl) Then yl=subword(yl,1,yi-1)
      Otherwise yl=subword(yl,1,yi-1) subword(yl,yi+1)
      End
    End
  End
line.=''                               /* empty the raster           */
Do i=1 To pp.0                         /* place the points           */
  Parse Var pp.i x y
  line.y=overlay('+',line.y,scale*(rr+x)+1)
  End
Do y=-rr To rr                         /* show the result            */
  Say line.y
  End
say pp.0 'points filled'
Exit
Return

take: Procedure Expose p. used.        /* add x to p. if its not used*/
  Parse Arg x y
  If used.x.y=0 Then Do
    z=p.0+1
    p.z=x y
    p.0=z
    End
  Return
