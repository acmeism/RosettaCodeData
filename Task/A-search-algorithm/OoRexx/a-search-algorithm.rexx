/* REXX */
Parse Arg which
If which='' Then       /* original input */
  Call init0
Else                   /* extended bars  */
  Call init

Do row=0 To 7
  maze=translate(row.row,'   ','{,}')
  Do col=0 to 7
    Parse var maze maze.row.col maze
    maz.row.col=maze.row.col
    End
  End
maze_rows=8
maze_cols=8

open=.queue~new
closed=.queue~new
path=.queue~new
parse Value '0 0' with xstart ystart
parse Value '7 7' with xend yend
now=.node~new(.nil,xstart,ystart,0,0)
diag=1
oi=0
path=findPathTo(xend,yend)

if path<>.nil Then Do
  Say "A minimum cost path:"
   i=0
   l=''
   Do pp over path
 --  Say i pp~y pp~x '->' pp~g
     l=l '['pp~y',' pp~x']'
     cost.i=pp~g
     end
  Say strip(l)
  Say "Total cost:" cost.i
l.1='+---+---+---+---+---+---+---+---+'
Do r=1 To 8
  lia=2*r
  lib=2*r+1
  l.lia='|   |   |   |   |   |   |   |   |'
  l.lib='+---+---+---+---+---+---+---+---+'
  End
Do r=0 To 7
  Do c=0 To 7
    If maz.r.c<>0 Then Do
      ll=(r+1)*2
      cc=(c+1)*4
      l.ll=overlay('X',l.ll,cc-1)
      End
    End
  End
i=0
Do pp over path
  i+=1
  r=pp~y
  c=pp~x
  ll=(r+1)*2
  cc=(c+1)*4-2
  Select
    When i=1 Then
      l.ll=overlay('-0-',l.ll,cc)
    When i=path~items Then
      l.ll=overlay('end',l.ll,cc)
    Otherwise
      l.ll=overlay(right(i-1,2),l.ll,cc)
    End
  end

Do li=1 to 17
  Say l.li
  End

  Do row=0 To 7
    l=''
    Do col=0 To 7
      Select
        When maze.row.col=0  Then l=l||'_'
        When maze.row.col=-1 Then l=l||'*'
        Otherwise                 l=l||'#'
        End
      End
    Say l
    End
  End
Else
  Say "No path found."
Exit

findPathTo:
  closed~append(now)
  Call addNeighborsToOpenList
  Do while now~x<>xend | now~y<>yend
    If open~items=0 Then
      return .nil
    now = open~remove(open~last)
    closed~append(now)
    Call addNeighborsToOpenList
    End
  path~push(now)
      xp=now~x
      yp=now~y
      maze.yp.xp=-1
  Do While now.parent<>.nil
    now = now~parent
    If now<>.nil Then do
      path~push(now)
      xp=now~x
      yp=now~y
      maze.yp.xp=-1
      End
    Else
      Leave
    End
  Call showp
  return path

addNeighborsToOpenList:
  Do x=-1 To 1
    Do y=-1 To 1
      If x=0 & y=0 Then Iterate
      If \diag & x<>0 & y<>0 Then Iterate
      nx=now~x + x;
      ny=now~y + y;
      if (nx<0 | ny<0 | ny>=maze_rows | nx>=maze_cols) Then Iterate
      If maze.ny.nx=-1 Then Iterate
      node=.node~new(now,nx,ny,now~g+1+maze.ny.nx,distance(x,y))
      fo=findNeighborInList(node,open)
      fc=findNeighborInList(node,closed)
      If \fo & \fc Then Do
        open~append(node)
        End
      End
    End
  oi+=1
--  Call Showo 'B'oi
  Call sort_open
--  Call Showo 'A'oi
  Return

findNeighborInList:
  Use Arg n,nl
  Do no Over nl
    If n~x=no~x & n~y=no~y Then
      Return 1
    End
  Return 0

distance:
  Parse Arg dx,dy
  xx=now~x+dx
  yy=now~y+dy
  If diag Then
    Return hypot(xx-xend,yy-yend)
  Else
    Return abs(xx-xend)+abs(yy-yend)

hypot:
  Parse Arg k1,k2
  Return rxCalcSqrt(k1**2+k2**2)

init0:
  row.0='{0, 0, 0, 0, 0, 0, 0, 0},'
  row.1='{0, 0, 0, 0, 0, 0, 0, 0},'
  row.2='{0, 0, 0,100,100,100,0,0},'
  row.3='{0, 0, 0, 0, 0,100, 0, 0},'
  row.4='{0, 0,100, 0, 0,100, 0, 0},'
  row.5='{0, 0,100, 0, 0,100, 0, 0},'
  row.6='{0, 0,100,100,100,100, 0, 0},'
  row.7='{0, 0, 0, 0, 0, 0,0, 0},'
  Return
init:
  row.0='{0, 0, 0, 0, 0, 0, 0, 0},'
  row.1='{0, 0, 0, 0, 0, 0, 0, 0},'
  row.2='{0, 0, 0,100,100,100,0,0},'
  row.3='{0, 0, 0, 0, 0,100, 0, 0},'
  row.4='{0, 0,100, 0, 0,100, 0, 0},'
  row.5='{0, 0,100, 0, 0,100, 0, 0},'
  row.6='{0,10,100,100,100,100,10,10},'
  row.7='{0, 0, 0, 0, 0, 0,0, 0},'
  Return

showo:
  Parse Arg tag
  l=''
  Do e over open
    Say '['e~x',' e~y'] ->'e~gh
    l=l '['e~x',' e~y']'
    End
  Say "                        "tag "open"l
  Return

showc:
  Call dbga arg(1)
  l=''
  Do e over close
    l=l '['e~x',' e~y']'
    End
  Call dbga "                        clos"l
  Return

showp:
  Call dbga arg(1)
  l=''
  Do e over path
    If e<>.nil Then
      l=l '['e~x',' e~y']'
    End
  Call dbga "                        path"l
  Return

sort_open:
/*
Sort the open queue ascending by gh
*/
   i=0
   a=.array~new
   as=.array~new
   Do e over open
     i+=1
     a[i]=e
     End
   n=i
   as[1]=a[1]
   m=1
   Do i=2 To n
     Do j=1 To m
       If a[i]~gh<=as[j]~gh Then
         Leave
       End
     Do k=m To j By -1
       as[k+1]=as[k]
       End
     as[j]=a[i]
     m+=1
     End
   Do i=1 To m
     Call dbg i as[i]~gh
     End
   open=.queue~new
   Do i=m To 1  By -1
     open~append(as[i])
     End
   Return

::Class node
::Attribute parent
::Attribute x
::Attribute y
::Attribute g
::Attribute h
::Attribute gh
::Method init
  Expose parent x y g h gh
  Use Arg p,xx,yy,gg,hh
  parent=p
  x=xx
  y=yy
  g=gg
  h=hh
  gh=g+h
  Call dbg "x="xx "y="yy "g="gg "h="hh "gh="gh

::method compareto                ---- this didn't work.
  use strict arg left, right
  Select
    When left~gh<right~gh Then return -1
    When left~gh=right~gh Then return 0
    When left~gh>right~gh Then return 1
    End

::Routine dbg  public
::Routine dbga public
  Return

::Requires rxMath Library
