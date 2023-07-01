/*--------------------------------------------------------------------
* Determine if two triangles overlap
* Fully (?) tested with integer coordinates of the 6 corners
* This was/is an exercise with ooRexx
* Removed the fraction arithmetic
*-------------------------------------------------------------------*/
Parse Version v

oid='trioo.txt'; 'erase' oid
Call o v
case=0
cc=0
Call trio_test '0 0   4 0   0 4   1 1   2  1   1 2'
Call trio_test '0 0 0 6 8 3 8 0 8 8 0 3'
Call trio_test '0 0 0 2 2 0 0 0 4 0 0 6'
/* The task's specified input */
Call trio_test '0 0 5 0 0 5 0 0 5 0 0 6'
Call trio_test '0 0 0 5 5 0 0 0 0 5 5 0'
Call trio_test '0 0 5 0 0 5 -10 0 -5 0 -1 6'
Call trio_test '0 0 5 0 2.5 5 0 4 2.5 -1 5 4'
Call trio_test '0 0 1 1 0 2 2 1 3 0 3 2'
Call trio_test '0 0 1 1 0 2 2 1 3 -2 3 4'
Call trio_test '0 0 1 0 0 1 1 0 2 0 1 1'
Exit
/* Other test cases */
Call trio_test '0 0   0 4   4 0   0 2   2  2   2 0'
Call trio_test '0 0   0 5   5 0   0 0   0  5   5 0'
Call trio_test '0 0   0 5   5 0   0 0   0  5   7 0'
Call trio_test '0 0   1 0   0 1   1 0   2  0   1 1'
Call trio_test '0 0   1 1   0 2   2 1   3  0   3 2'
Call trio_test '0 0   1 1   0 2   2 1   3 -2   3 4'
Call trio_test '0 0   2 0   2 2   3 3   5  3   5 5'
Call trio_test '0 0   2 0   2 3   0 0   2  0   2 3'
Call trio_test '0 0   4 0   0 4   0 2   2  0   2 2'
Call trio_test '0 0   4 0   0 4   1 1   2  1   1 2'
Call trio_test '0 0   5 0   0 2   5 0   8  0   4 8'
Call trio_test '0 0   5 0   0 5   0 0   5  0   0 6'
Call trio_test '0 0   5 0   0 5 -10 0  -5  0  -1 6'
Call trio_test '0 0   5 0   0 5  -5 0  -1  6  -3 0'
Call trio_test '0 0   5 0   3 5   0 4   3 -1   5 4'
Call trio_test '0 0   6 0   4 6   1 1   4  2   7 1'
Call trio_test '0 1   0 4   2 2   3 1   3  4   5 2'
Call trio_test '1 0   3 0   2 2   1 3   3  3   2 2'
Call trio_test '1 0   3 0   2 2   1 3   3  3   2 5'
Call trio_test '1 1   4 2   7 1   0 0   8  0   4 8'
Call trio_test '2 0   2 6   1 8   0 1   0  5   8 3'
Call trio_test '0 0   4 0   0 4   1 1   2  1   1 2'
Say case 'cases tested'
Say cc
Exit

trio_test:
Parse Arg tlist
cc+=1
tlist=space(tlist)
tl1=tlist                              ; Call trio_t tl1
tl2=reversex(tlist)                    ; Call trio_t tl2
tl3=''
tl=tlist
Do While tl<>''
  Parse Var tl x y tl
  tl3=tl3 y x
  End
                                         Call trio_t tl3
tl4=reversex(tl3)                      ; Call trio_t tl4
tl5=subword(tl4,7) subword(tl4,1,6)    ; Call trio_t tl5
tl6=subword(tl5,7) subword(tl5,1,6)    ; Call trio_t tl6
Return

trio_t:
Parse Arg tlist
tlist=space(tlist)
Say tlist
case+=1
Parse Arg ax ay bx by cx cy dx dy ex ey fx fy
/*---------------------------------------------------------------------
* First build the objects needed
*--------------------------------------------------------------------*/
a=.point~new(ax,ay); b=.point~new(bx,by); c=.point~new(cx,cy)
d=.point~new(dx,dy); e=.point~new(ex,ey); f=.point~new(fx,fy)
abc=.triangle~new(a,b,c)
def=.triangle~new(d,e,f)
Call o 'Triangle: ABC:' abc ,1
Call o 'Edges of ABC:'; Do i=1 To 3; Call o ' 'abc~edge(i); End
Call o 'Triangle: DEF:' def ,1
Call o 'Edges of DEF:'; Do i=1 To 3; Call o ' 'def~edge(i); End
pixl=' '
Do i=1 To 3
  pixl=pixl abc~draw(i,'O')
  pixl=pixl def~draw(i,'*')
  End
res=0
fc=0
touch=0
bordl=''
Do i=1 To 3
  p1=abc~point(i)
  p2=def~point(i)
  Do j=1 To 3
    e1=abc~edge(j)
    e2=def~edge(j)
    If e1~contains(p2) Then Do
      Call o e1 'contains' p2
      ps=p2~string
      If wordpos(ps,bordl)=0 Then Do
        bordl=bordl ps
        touch+=1
        End
      End
    Else
      Call o e1 'does not contain' p2 i j
    If e2~contains(p1) Then Do
      Call o e2 'contains' p1
      ps=p1~string
      If wordpos(ps,bordl)=0 Then Do
        bordl=bordl ps
        touch+=1
        End
      End
    Else
      Call o e2 'does not contain' p1
    End
  End

wb=words(bordl)                     /* how many of them?             */
If wb>0 Then
  Call o 'Corner(s) that touch the other triangle:' bordl,1

/*---------------------------------------------------------------------
* How many of them are corners of both triangles
*--------------------------------------------------------------------*/
m=0
cmatch=''
do i=1 To 3
  If wordpos(abc~point(i),bordl)>0 &,
     wordpos(abc~point(i),def)>0 Then Do
    cmatch=cmatch abc~point(i)
    m+=1
    End
  End

/*---------------------------------------------------------------------
* With two or three touching corners we show the result and return
*--------------------------------------------------------------------*/
Select
  When wb=3 Then Do                 /* all three touch               */
    Call draw(pixl)
    Select
      When m=3 Then
        Call o 'Triangles are identical',1
      When m=2 Then
        Call o 'Triangles have an edge in common:' cmatch,1
      Otherwise
        Call o 'Triangles overlap and touch on' bordl,1
      End
    Call o '',1
 --   Pull .
    Return
    End
  When wb=2 Then Do                 /* two of them match             */
    Call draw(pixl)
    If m=2 Then
      Call o 'Triangles have an edge in common:' cmatch,1
    Else
      Call o 'Triangles overlap and touch on' bordl,1
    Call o ''
 --   Pull .
    Return
    End
  When wb=1 Then Do                 /* one of them matches          */
    Call o 'Triangles touch on' bordl,1 /* other parts may overlap  */
    Call o '  we analyze further',1
    End
  Otherwise                         /* we know nothing yet           */
    Nop
  End

/*---------------------------------------------------------------------
* Now we look for corners of abc that are within the triangle def
*--------------------------------------------------------------------*/
in_def=0
Do i=1 To 3
  p=abc~point(i)
  Call o 'p  ='p
  Call o 'def='def
  If def~contains(p) &,
    wordpos(p,bordl)=0 Then Do
    Call o def 'contains' p
    in_def+=1
    End
  End

If in_def=3 Then Do
  Call o abc 'is fully contained in' def,1
  Call o '',1
  Call draw(pixl)
  fc=1
  End
res=(in_def>0)
/*---------------------------------------------------------------------
* Now we look for corners of def that are within the triangle abc
*--------------------------------------------------------------------*/
If res=0 Then Do
  in_abc=0
  If res=0 Then Do
    Do i=1 To 3
      p=def~point(i)
      Call o 'p  ='p
      Call o 'def='def
      If abc~contains(p) &,
         wordpos(p,bordl)=0 Then Do
        Call o abc 'contains' p
        in_abc+=1
        End
      End
    End
  If in_abc=3 Then Do
    Call o def 'is fully contained in' abc,1
    Call o '',1
    Call draw(pixl)
    fc=1
    End
  res=(in_abc>0)

  End

/*---------------------------------------------------------------------
* Now we check if some edge of abc crosses any edge of def
*--------------------------------------------------------------------*/
If res=0 Then Do
  Do i=1 To 3
    Do j=1 To 3
      e1=abc~edge(i); Call o 'e1='e1
      e2=def~edge(j); Call o 'e2='e2
      Call o 'crossing???'
      res=e1~crosses(e2)
If res Then Do
  End
      If res Then
        Call o 'edges cross'
      Else
        Call o 'edges don''t cross'
      End
    End
  End

If fc=0 Then Do                     /* no fully contained            */
  Call draw(pixl)
  If res=0 Then                     /* no overlap                    */
    If wb=1 Then                    /* but one touching corner       */
      call o abc 'and' def 'don''t overlap but touch on' bordl,1
    Else
      call o abc 'and' def 'don''t overlap',1
  Else                              /* overlap                       */
    If wb>0 Then                    /* one touching corner           */
      call o abc 'and' def 'overlap and touch on' bordl,1
    Else
      call o abc 'and' def 'overlap',1
  Call o '',1
--  Pull .
  End
Return

/*---------------------------------------------------------------------
* And here are all the classes and methods needed:
* point         init, x, y, string
* triangle      init, point, edge, contains, string
* edge          init, p1, p2, kdx, contains, crosses, string
*--------------------------------------------------------------------*/

::class point public
::attribute x
::attribute y
::method init
  expose x y
  use arg x,y
::method string
  expose x y
  return "("||x","y")"

::class triangle public
::method init
  expose point edge
  use arg p1,p2,p3
  point=.array~new
  point[1]=p1
  point[2]=p2
  point[3]=p3
  edge=.array~new
  Do i=1 To 3
    ia=i+1; If ia=4 Then ia=1
    edge[i]=.edge~new(point[i],point[ia])
    End
::method point
  expose point
  use arg n
  Return point[n]
::method edge
  expose edge
  use arg n
  Return edge[n]
::method contains
  expose point edge
  use arg pp
  Call o self
  Call o 'pp='pp
  xmin=1.e9
  ymin=1.e9
  xmax=-1.e9
  ymax=-1.e9
  Do i=1 To 3
    e=edge[i]
    Parse Value e~kdx With ka.i da.i xa.i
    Call o show_g(ka.i,da.i,xa.i)
    p1=e~p1
    p2=e~p2
    xmin=min(xmin,p1~x,p2~x)
    xmax=max(xmax,p1~x,p2~x)
    ymin=min(ymin,p1~y,p2~y)
    ymax=max(ymax,p1~y,p2~y)
    End
  If pp~x<xmin|pp~x>xmax|pp~y<ymin|pp~y>ymax Then
    res=0
  Else Do
    e=edge[1]
    e2=edge[2]
    p1=e2~p1
    p2=e2~p2
    Call o 'e:' e
    Select
      When ka.1='*' Then Do
        y2=ka.2*pp~x+da.2
        y3=ka.3*pp~x+da.3
        res=between(y2,pp~y,y3)
        End
      When ka.2='*' Then Do
        y2=ka.1*pp~x+da.1
        res=between(p1~y,y2,p2~y)
        End
      Otherwise Do
        dap=pp~y-ka.1*pp~x
        If ka.3='*' Then
          x3=xa.3
        Else
          x3=(da.3-dap)/(ka.1-ka.3)
        x2=(da.2-dap)/(ka.1-ka.2)
        res=between(x2,pp~x,x3)
        End
      End
    End
  Return res
::method string
  expose point
  ol=''
  Do p over point
    ol=ol p~string
    End
  return ol
::method draw
  expose point
  Use Arg i,c
  p=self~point(i)
  Return p~x p~y c
::class edge public
::method init
  expose edge p1 p2
  use arg p1,p2
  edge=.array~new
  edge[1]=p1
  edge[2]=p2
::method p1
  expose edge p1 p2
  return p1
::method p2
  expose edge p1 p2
  return p2
::method kdx
  expose edge p1 p2
  x1=p1~x
  y1=p1~y
  x2=p2~x
  y2=p2~y
  If x1=x2 Then Do
    Parse Value '*' '-' x1 With ka da xa
      Call o show_g(ka,da,xa)
    End
  Else Do
    ka=(y2-y1)/(x2-x1)
    da=y2-ka*x2
    xa='*'
    End
  Return ka da xa
::method contains
  Use Arg p
  p1=self~p1
  p2=self~p2
  parse Value self~kdx With k d x
  If k='*' Then Do
    res=(p~x=p1~x)&between(p1~y,p~y,p2~y,'I')
    End
  Else Do
    ey=k*p~x+d
    res=(ey=p~y)&between(p1~x,p~x,p2~x,'I')
    End
  If res Then Call o self 'contains' p
         Else Call o self 'does not contain' p
  Return res
::method crosses
  expose p1 p2
  Use Arg e
  q1=e~p1
  q2=e~p2
  Call o 'Test if' e 'crosses' self
  Call o self~kdx
  Call o e~kdx
  Parse Value self~kdx With ka da xa; Call o ka da xa
    Call o show_g(ka,da,xa)
  Parse Value    e~kdx With kb db xb; Call o kb db xb
    Call o show_g(kb,db,xb)
  Call o 'ka='ka
  Call o 'kb='kb
  Select
    When ka='*' Then Do
      If kb='*' Then Do
        res=(xa=xb)
        End
      Else Do
        Call o 'kb='kb 'xa='||xa  'db='db
        yy=kb*xa+db
        res=between(q1~y,yy,q2~y)
        End
      End
    When kb='*' Then Do
      yy=ka*xb+da
      res=between(p1~y,yy,p2~y)
      End
    When ka=kb Then Do
      If da=db Then Do
        If min(p1~x,p2~x)>max(q1~x,q2~x) |,
           min(q1~x,q2~x)>max(p1~x,p2~x) Then
          res=0
        Else Do
          res=1
          End
        End
      Else
        res=0
      End
    Otherwise Do
      x=(db-da)/(ka-kb)
      y=ka*x+da
      Call o 'cross:' x y
      res=between(p1~x,x,p2~x)
      End
    End
  Return res
::method string
  expose edge p1 p2
  ol=p1~string'-'p2~string
  return ol

::routine between         /* check if a number is between two others */
  Use Arg a,x,b,inc
  Call o 'between:' a x b
  Parse Var a anom '/' adenom
  Parse Var x xnom '/' xdenom
  Parse Var b bnom '/' bdenom
  If adenom='' Then adenom=1
  If xdenom='' Then xdenom=1
  If bdenom='' Then bdenom=1
  aa=anom*xdenom*bdenom
  xx=xnom*adenom*bdenom
  bb=bnom*xdenom*adenom
  If inc='I' Then
    res=sign(xx-aa)<>sign(xx-bb)
  Else
    res=sign(xx-aa)<>sign(xx-bb) & (xx-aa)*(xx-bb)<>0
  Call o a x b 'res='res
  Return res

::routine show_g          /* show a straight line's forula           */
/*---------------------------------------------------------------------
* given slope, y-distance, and (special) x-value
* compute y=k*x+d or, if a vertical line, k='*'; x=c
*--------------------------------------------------------------------*/
  Use Arg k,d,x
  Select
    When k='*' Then res='x='||x       /* vertical line               */
    When k=0   Then res='y='d         /* horizontal line             */
    Otherwise Do                      /* ordinary line               */
      Select
        When k=1  Then res='y=x'dd(d)
        When k=-1 Then res='y=-x'dd(d)
        Otherwise      res='y='k'*x'dd(d)
        End
      End
    End
  Return res

::routine dd  /* prepare a displacement for presenting it in show_g  */
/*---------------------------------------------------------------------
* prepare y-distance for display
*--------------------------------------------------------------------*/
  Use Arg dd
  Select
    When dd=0 Then dd=''            /* omit dd if it's zero          */
    When dd<0 Then dd=dd            /* use dd as is (-value)         */
    Otherwise      dd='+'dd         /* prepend '+' to positive dd    */
    End
  Return dd

::routine o               /* debug output                            */
  Use Arg txt,say
  If say=1 Then
    Say txt
  oid='trioo.txt'
  Return lineout(oid,txt)

::routine draw
  Use Arg pixl
    Return                       /* remove to see the triangle corners */
  Say 'pixl='pixl
  pix.=' '
  Do While pixl<>''
    Parse Var pixl x y c pixl
    x=2*x+16; y=2*y+4
    If pix.x.y=' ' Then
      pix.x.y=c
    Else
      pix.x.y='+'
    End
  Do j= 20 To 0 By -1
    ol=''
    Do i=0 To 40
      ol=ol||pix.i.j
      End
    Say ol
    End
    Return
::routine reversex
  Use Arg list
  n=words(list)
  res=word(list,n)
  Do i=n-1 to 1 By -1
    res=res word(list,i)
    End
  Return res
