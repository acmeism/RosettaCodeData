/**************************
44 Solomon  1 1 1 1 1
42 Jason    2 3 2 2 2.5
42 Errol    2 3 2 3 2.5
41 Garry    4 6 3 4 5
41 Bernard  4 6 3 5 5
41 Barry    4 6 3 6 5
39 Stephen  7 7 4 7 7
**************************/
Do i=1 To 7
  Parse Value sourceline(i+1) With rank.i name.i .
  /* say rank.i name.i */
  End
pool=0
crank=0
Do i=1 To 7
  If rank.i<>crank Then Do
    pool=pool+1
    lo.pool=i
    hi.pool=i
    n.pool=1
    ii.pool=i
    End
  Else Do
    n.pool=n.pool+1
    hi.pool=i
    ii.pool=ii.pool+i
    End
  crank=rank.i
  pool.i=pool
  End
/*
Do j=1 To pool
  Say 'pool' j n.j lo.j hi.j
  End
*/
cp=0
r=0
cnt.=0
Do i=1 To 7
  p=pool.i
  If p<>cp Then
    r=r+1
  res=rank.i left(name.i,8) lo.p hi.p r i ii.p/n.p
  If res=sourceline(i+1) Then cnt.ok=cnt.ok+1
  Say res
  cp=p
  End
Say cnt.ok 'correct lines'
