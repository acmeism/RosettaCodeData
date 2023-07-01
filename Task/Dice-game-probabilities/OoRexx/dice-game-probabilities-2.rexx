Numeric Digits 30
Call test '9 4 6 6'
Call test '5 10 6 7'
Exit

test:
Parse Arg w1 s1 w2 s2
p1.='0/1'
p2.='0/1'
Call pp 1,w1,s1,p1.,p2.
Call pp 2,w2,s2,p1.,p2.
p2low.='0/1'
Do x=w1 To w1*s1
  Do y=0 To x-1
    p2low.x=fr_add(p2low.x,p2.y)
    End
  End
pwin1='0/1'
Do x=w1 To w1*s1
  pwin1=fr_add(pwin1,fr_Mult(p1.x,p2low.x))
  End
Say 'Player 1 has' w1 'dice with' s1 'sides each'
Say 'Player 2 has' w2 'dice with' s2 'sides each'
Say 'Probability for player 1 to win:' pwin1
Parse Var pwin1 nom '/' denom
Say '                              ->' (nom/denom)
Say ''
Return

pp: Procedure
/*---------------------------------------------------------------------
* Compute and assign probabilities to get a sum x
* when throwing w dice each having s sides (marked from 1 to s)
* k=1 sets p1.*, k=2 sets p2.*
*--------------------------------------------------------------------*/
Use Arg k,w,s,p1.,p2.
str=''
cnt.=0
Do wi=1 To w
  str=str||'Do v'wi'=1 To' s';'
  End
str=str||'sum='
Do wi=1 To w-1
  str=str||'v'wi'+'
  End
str=str||'v'w';'
str=str||'cnt.sum+=1;'
Do wi=1 To w
  str=str||'End;'
  End
Interpret str

psum='0/1'
Do x=0 To w*s
  If k=1 Then
    p1.x=cnt.x'/'||(s**w)
  Else
    p2.x=cnt.x'/'||(s**w)
  psum=fr_add(psum,p1.x)
  End
Return


fr_add: Procedure
Parse Arg a,b
parse Var a an '/' az
parse Var b bn '/' bz
rn=an*bz+bn*az
rz=az*bz
res=fr_cancel(rn','rz)
Return res

fr_div: Procedure
Parse Arg a,b
parse Var a an '/' az
parse Var b bn '/' bz
rn=an*bz
rz=az*bn
res=fr_cancel(rn','rz)
Return res

fr_mult: Procedure
Parse Arg a,b
parse Var a an '/' az
parse Var b bn '/' bz
rn=an*bn
rz=az*bz
res=fr_cancel(rn','rz)
Return res

fr_cancel: Procedure
Parse Arg n ',' z
k=ggt(n,z)
Return n%k'/'z%k

ggt: Procedure
/**********************************************************************
* ggt (gcd) Greatest common Divisor
* Recursive procedure as shown in PL/I
**********************************************************************/
Parse Arg a,b
if b = 0 then return abs(a)
return ggt(b,a//b)
