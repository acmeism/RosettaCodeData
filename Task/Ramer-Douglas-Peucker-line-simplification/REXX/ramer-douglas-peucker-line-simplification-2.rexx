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
    Parse Var plc '(' x ',' y ')' plc
    p.i=x y
    End
  end=i-1
  dmax=0
  index=0
  Do i=2 To end-1
    d=distpg(p.i,p.1,p.end)
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

distpg: Procedure
/**********************************************************************
* compute the distance of point P from the line giveb by A and B
**********************************************************************/
  Parse Arg P,A,B
  Parse Var P px py
  Parse Var A ax ay
  Parse Var B bx by
  If ax=bx Then
    res=px-ax
  Else Do
    k=(by-ay)/(bx-ax)
    d=(ay-ax*k)
    res=(py-k*px-d)/sqrt(1+k**2)
    End
  Return abs(res)
sqrt: Procedure
/* REXX ***************************************************************
* EXEC to calculate the square root of a = 2 with high precision
**********************************************************************/
  Parse Arg x,prec
  If prec<9 Then prec=9
  prec1=2*prec
  eps=10**(-prec1)
  k = 1
  Numeric Digits 3
  r0= x
  r = 1
  Do i=1 By 1 Until r=r0 | (abs(r*r-x)<eps)
    r0 = r
    r  = (r + x/r) / 2
    k  = min(prec1,2*k)
    Numeric Digits (k + 5)
    End
  Numeric Digits prec
  r=r+0
  Return r
