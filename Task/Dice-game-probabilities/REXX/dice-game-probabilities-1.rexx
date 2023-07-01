/* REXX */
Numeric Digits 30
Call test '9 4 6 6'
Call test '5 10 6 7'
Exit
test:
Parse Arg w1 s1 w2 s2
plist1=pp(w1,s1)
p1.=0
Do x=w1 To w1*s1
  Parse Var plist1 p1.x plist1
  End
plist2=pp(w2,s2)
p2.=0
Do x=w2 To w2*s2
  Parse Var plist2 p2.x plist2
  End
p2low.=0
Do x=w1 To w1*s1
  Do y=0 To x-1
    p2low.x=p2low.x+p2.y
    End
  End
pwin1=0
Do x=w1 To w1*s1
  pwin1=pwin1+p1.x*p2low.x
  End
Say 'Player 1 has' w1 'dice with' s1 'sides each'
Say 'Player 2 has' w2 'dice with' s2 'sides each'
Say 'Probability for player 1 to win:' pwin1
Say ''
Return

pp: Procedure
/*---------------------------------------------------------------------
* Compute and return the probabilities to get a sum x
* when throwing w dice each having s sides (marked from 1 to s)
*--------------------------------------------------------------------*/
Parse Arg w,s
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
str=str||'cnt.'sum'=cnt.'sum'+1;'
Do wi=1 To w
  str=str||'End;'
  End
Interpret str
psum=0
Do x=0 To w*s
  p.x=cnt.x/(s**w)
  psum=psum+p.x
  End
res=''
Do x=w To s*w
  res=res p.x
  End
Return res
