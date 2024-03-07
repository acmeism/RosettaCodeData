/*REXX program uses the Ramer-Douglas-Peucker (RDP) line simplification algorithm  for*/
/*--------------------------- reducing the number of points used to define its shape. */
Parse Arg epsilon pl                           /*obtain optional arguments from the CL*/
If epsilon='' | epsilon=',' then epsilon= 1    /*Not specified?  Then use the default.*/
If pl='' Then pl= '(0,0) (1,0.1) (2,-0.1) (3,5) (4,6) (5,7) (6,8.1) (7,9) (8,9) (9,9)'
Say '  error threshold:' epsilon
Say ' points specified:' pl
Say 'points simplified:' dlp(pl)
Exit
dlp: Procedure Expose epsilon
  Parse Arg pl
  plc=pl
  Do i=1 By 1 While plc<>''
    Parse Var plc '(' X ',' y ')' plc
    p.i=.point~new(x,y)
    End
  end=i-1
  dmax=0
  index=0
  Do i=2 To end-1
    d=distpg(p.i,.line~new(p.1,p.end))
    If d>dmax Then Do
      index=i
      dmax=d
      End
    End
  If dmax>epsilon Then Do
    rla=dlp(subword(pl,1,index))
    rlb=dlp(subword(pl,index,end))
    rl=subword(rla,1,words(rla)-1) rlb
    End
  Else
    rl=word(pl,1) word(pl,end)
  Return rl

::CLASS point public
::ATTRIBUTE X
::ATTRIBUTE Y
::METHOD init   PUBLIC
  Expose X Y
  Use Arg X,Y

::CLASS line public
::ATTRIBUTE A
::ATTRIBUTE B
::METHOD init   PUBLIC
  Expose A B
  Use Arg A,B
  If A~x=B~x & A~y=B~y Then Do
    Say 'not a line'
    Return .nil
    End

::METHOD k      PUBLIC
  Expose A B
  ax=A~x; ay=A~y; bx=B~x; by=B~y
  If ax=bx Then
    res='infinite'
  Else
    res=(by-ay)/(bx-ax)
  Return res

::METHOD d      PUBLIC
  Expose A B
  ax=A~x; ay=A~y
  If self~k='infinite' Then
    res='indeterminate'
  Else
    res=round(ay-ax*self~k)
  Return res

::ROUTINE distpg  PUBLIC --Compute the distance from a point to a line
/***********************************************************************
* Compute the distance from a point to a line
***********************************************************************/
  Use Arg A,g
  ax=A~x; ay=A~y
  k=g~k
  If k='infinite' Then Do
    Parse Value g~kxd With 'x='gx
    res=gx-ax
    End
  Else
    res=(ay-k*ax-g~d)/rxCalcsqrt(1+k**2)
  Return abs(res)

::ROUTINE round   PUBLIC --Round a number to 3 decimal digits
/***********************************************************************
* Round a nmber to 3 decimal digits
***********************************************************************/
  Use Arg z,d
  Numeric Digits 30
  res=z+0
  If d>'' Then
    res=format(res,9,6)
  Return strip(res)

::requires rxMath library
