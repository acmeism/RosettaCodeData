/* REXX ---------------------------------------------------------------
* 02.08.2014 Walter Pachl
* Input is a file containing the initial pattern
* The compute area is extended when needed
*   (cells are born outside the current compute area)
* The program stops when the picture shown is the same as the first
*   or equal to the previous one
*--------------------------------------------------------------------*/
Parse Arg f
If f='' Then f='bipole'
fid=f'.in'
oid=f'.txt'; 'erase' oid
debug=0
If debug Then Do
  dbg=f'.xxx'; 'erase' dbg
  End
ml=0
l.=''
Do ri=3 By 1 While lines(fid)>0
  l.ri='  'linein(fid)
  ml=max(ml,length(strip(l.ri,'T')))
  End
ml=ml+2
ri=ri+1
yy=ri
If debug Then
  say 'ml='ml 'yy='yy
yb=1
a.=' '
b.=' '
m.=''
x.=''
Parse Value 1 ml 1 yy With xmi xma ymi yma
Parse Value '999 0' With xmin xmax
Parse Value '999 0' With ymin ymax

Do y=1 To yy
  z=yy-y-1
  l=l.z
  Do x=1 By 1 While l<>''
    Parse Var l c +1 l
    If c='*' Then Do
      a.x.z='*'
      End
    End
  End
Call show
Do step=1 To 60
  Call store
  If step>1 & is_equal(step,1) Then Leave
  If step>1 & is_equal(step,step-1) Then Leave
    Call show_neighbors
  Do y=yma To ymi By -1
    ol=format(x,2)' '
    Do x=xmi To xma
      neighbors=neighbors(x,y)
      If a.x.y=' ' Then Do             /* dead cell                  */
        If neighbors=3 Then Do
          b.x.y='*'                    /*  gets life                 */
          mmo=xmi xma ymi yma
          xmi=min(xmi,x-1)
          xma=max(xma,x+1)
          ymi=min(ymi,y-1)
          yma=max(yma,y+1)
          mm=xmi xma ymi yma
          If mm<>mmo Then
            Call debug mmo '->' mm
          End
        Else                           /* life cell                  */
          b.x.y=' '                    /*  remains dead              */

        End
      Else Do                          /* life cell                  */
        If neighbors=2 |,
           neighbors=3 Then b.x.y='*'  /*  remains life              */
                       Else b.x.y=' '  /*  dies                      */
        End
      End
    End
  /* b. is the new state and is now copied to a.                     */
  Do y=yma To ymi By -1
    Do x=xmi To xma
      a.x.y=b.x.y
      End
    End
  End
/* Output name and all states                                        */
Call lineout oid,' 'f
st=' +'                                /* top and bottom border      */
sb=' +'                                /* top and bottom border      */
Do s=1 To step
  st=st||'-'right(s,2,'-')||copies('-',xmax-xmin)'+'
  sb=sb||copies('-',xmax-xmin+3)'+'
  End
Call lineout oid,st                    /* top border                 */
Do y=ymin To ymax
  ol=''
  Do s=1 To step
    ol=ol '|' substr(m.s.y,xmin,xmax-xmin+1)
    End
  Call lineout oid,ol '|'
  End
Call lineout oid,sb                    /* bottom border              */
Call lineout oid
'type' oid
If debug Then Do
  Say 'original area' 1 ml '/' 1 yy
  Say 'compute area ' xmi xma '/' ymi yma
  End
Exit

set: Parse Arg x,y
     a.x.y='*'
     Return

neighbors: Procedure Expose a. debug
  Parse Arg x,y
  neighbors=0
  do xa=x-1 to x+1
    do ya=y-1 to y+1
      If xa<>x | ya<>y then
        If a.xa.ya='*' Then
          neighbors=neighbors+1
      End
    End
  Return neighbors

store:
/* store current state (a.) in lines m.step.*                        */
Do y=yy To 1 By -1
  ol=''
  Do x=1 To ml
    z=a.x.y
    ol=ol||z
    End
  x.step.y=ol
  If ol<>'' then Do
    ymin=min(ymin,y)
    ymax=max(ymax,y)
    p=pos('*',ol)
    q=length(strip(ol,'T'))
    If p>0 Then
      xmin=min(xmin,p)
    xmax=max(xmax,q)
    End
  m.step.y=ol
  Call debug '====>' right(step,2) y ol  xmin xmax
  End
Return

is_equal:
/* test ist state a.b is equal to state a.a                          */
  Parse Arg a,b
  Do y=yy To 1 By -1
    If x.b.y<>x.a.y Then
      Return 0
    End
  Return 1

show: Procedure Expose dbg a. yy ml debug
Do y=1 To yy
  ol='>'
  Do x=1 To ml
    ol=ol||a.x.y
    End
  Call debug ol
  End
Return

show_neighbors: Procedure Expose a. xmi xma ymi yma dbg debug
  Do y=yma To ymi By -1
    ol=format(y,2)' '

    Do x=xmi To xma
      ol=ol||neighbors(x,y)
      End
    Call debug ol
    End
  Return

debug:
  If debug Then
    Return lineout(dbg,arg(1))
  Else
    Return
