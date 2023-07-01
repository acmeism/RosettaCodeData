debug=0
If debug Then Do
  oid='sppn.txt'; 'erase' oid
  End
Call time 'R'
all_pairs=''
cnt.=0
i=0
/* first take all possible pairs 2<=x<y with x+y<=100 */
/* and compute the respective sums and products       */
/* count the number of times a sum or product occurs  */
Do x=2 To 98
  Do y=x+1 To 100-x
    x=right(x,2,0)
    y=right(y,2,0)
    all_pairs=all_pairs x'/'y
    i=i+1
    x.i=x
    y.i=y
    sum=x+y
    prd=x*y
    cnt.0s.sum=cnt.0s.sum+1
    cnt.0p.prd=cnt.0p.prd+1
    End
  End
n=i
/* now compute the possible pairs for each sum sum_d.sum */
/*                                 and product prd_d.prd */
/* also the list of possible sums and products suml, prdl*/
sum_d.=''
prd_d.=''
suml=''
prdl=''
Do i=1 To n
  x=x.i
  y=y.i
  x=right(x,2,0)
  y=right(y,2,0)
  sum=x+y
  prd=x*y
  cnt.0s.x.y=cnt.0s.sum
  cnt.0p.x.y=cnt.0p.prd
  sum_d.sum=sum_d.sum x'/'y
  prd_d.prd=prd_d.prd x'/'y
  If wordpos(sum,suml)=0 Then suml=suml sum
  If wordpos(prd,prdl)=0 Then prdl=prdl prd
  End
Say n 'possible pairs'
Call o 'SUM'
suml=wordsort(suml)
prdl=wordsort(prdl)
sumlc=suml
si=0
pi=0
Do While sumlc>''
  Parse Var sumlc sum sumlc
  si=si+1
  sum.si=sum
  si.sum=si
  If sum=17 Then sx=si
  temp=prdl
  Do While temp>''
    Parse Var temp prd temp
    If si=1 Then Do
      pi=pi+1
      prd.pi=prd
      pi.prd=pi
      If prd=52 Then px=pi
      End
    A.prd.sum='+'
    End
  End
sin=si
pin=pi
Call o 'SUM'
Do si=1 To sin
  Call o f5(si) f3(sum.si)
  End
Call o 'PRD'
Do pi=1 To pin
  Call o f5(pi) f6(prd.pi)
  End
a.='-'
Do pi=1 To pin
  prd=prd.pi
  Do si=1 To sin
    sum=sum.si
    Do sj=1 To words(sum_d.sum)
      If wordpos(word(sum_d.sum,sj),prd_d.prd)>0 Then
        Parse Value word(sum_d.sum,sj) with x '/' y
        prde=x*y
        sume=x+y
        pa=pi.prde
        sa=si.sume
        a.pa.sa='+'
      End
    End
  End
Call show '1'

Do pi=1 To pin
  prow=''
  cnt=0
  Do si=1 To sin
    If a.pi.si='+' Then Do
      cnt=cnt+1
      pj=pi
      sj=si
      End
    End
  If cnt=1 Then
    a.pj.sj='1'
  End
Call show '2'

Do si=1 To sin
  Do pi=1 To pin
    If a.pi.si='1' Then Leave
    End
  If pi<=pin Then Do
    Do pi=1 To pin
      If a.pi.si='+' Then
        a.pi.si='2'
      End
    End
  End
Call show '3'

Do pi=1 To pin
  prow=''
  Do si=1 To sin
    prow=prow||a.pi.si
    End
  If count('+',prow)>1 Then Do
    Do si=1 To sin
      If a.pi.si='+' Then
        a.pi.si='3'
      End
    End
  End
Call show '4'

Do si=1 To sin
  scol=''
  Do pi=1 To pin
    scol=scol||a.pi.si
    End
  If count('+',scol)>1 Then Do
    Do pi=1 To pin
      If a.pi.si='+' Then
        a.pi.si='4'
      End
    End
  End
Call show '5'

sol=0
Do pi=1 To pin
  Do si=1 To sin
    If a.pi.si='+' Then Do
      Say sum.si prd.pi
      sum=sum.si
      prd=prd.pi
      sol=sol+1
      End
    End
  End
Say sol 'solution(s)'
Say '            possible pairs'
Say 'Product='prd prd_d.52
Say '    Sum='sum sum_d.17
Say 'The only pair in both lists is 04/13.'
Say 'Elapsed time:' time('E') 'seconds'
Exit
show:
If debug Then Do
  Call o 'show' arg(1)
  Do pi=1 To 60
    ol=''
    Do si=1 To 60
      ol=ol||a.pi.si
      End
    Call o ol
    End
  Say 'a.'px'.'sx'='a.px.sx
  End
Return

Exit
o: Return lineout(oid,arg(1))
f3: Return format(arg(1),3)
f4: Return format(arg(1),4)
f5: Return format(arg(1),5)
f6: Return format(arg(1),6)

count: Procedure
  Parse Arg c,s
  s=translate(s,c,c||xrange('00'x,'ff'x))
  s=space(s,0)
  Return length(s)
wordsort: Procedure
/**********************************************************************
* Sort the list of words supplied as argument. Return the sorted list
**********************************************************************/
  Parse Arg wl
  wa.=''
  wa.0=0
  Do While wl<>''
    Parse Var wl w wl
    Do i=1 To wa.0
      If wa.i>w Then Leave
      End
    If i<=wa.0 Then Do
      Do j=wa.0 To i By -1
        ii=j+1
        wa.ii=wa.j
        End
      End
    wa.i=w
    wa.0=wa.0+1
    End
  swl=''
  Do i=1 To wa.0
    swl=swl wa.i
    End
  /* Say swl */
  Return strip(swl)
