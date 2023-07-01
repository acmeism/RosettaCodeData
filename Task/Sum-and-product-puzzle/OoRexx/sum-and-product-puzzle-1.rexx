all      =.set~new
Call time 'R'
cnt.=0
do a=2 to 100
  do b=a+1 to 100-2
    p=a b
    if a+b>100 then leave b
    all~put(p)
    prd=a*b
    cnt.prd+=1
    End
  End
Say "There are" all~items "pairs where X+Y <=" max "(and X<Y)"

spairs=.set~new
Do Until all~items=0
  do p over all
    d=decompositions(p)
    If take Then
      spairs=spairs~union(d)
    dif=all~difference(d)
    Leave
    End
  all=dif
  end
Say "S starts with" spairs~items "possible pairs."

sProducts.=0
Do p over sPairs
  Parse Var p x y
  prod=x*y
  sProducts.prod+=1
  End

pPairs=.set~new
Do p over sPairs
  Parse Var p xb yb
  prod=xb*yb
  If sProducts.prod=1 Then
    pPairs~put(p)
  End
Say "P then has" pPairs~items "possible pairs."

Sums.=0
Do p over pPairs
  Parse Var p xc yc
  sum=xc+yc
  Sums.sum+=1
  End

final=.set~new
Do p over pPairs
  Parse Var p x y
  sum=x+y
  If Sums.sum=1 Then
    final~put(p)
  End

si=0
Do p Over final
  si+=1
  sol.si=p
  End
Select
  When final~items=1 Then Say "Answer:" sol.1
  When final~items=0 Then Say "No possible answer."
  Otherwise Do;            Say final~items "possible answers:"
                           Do p over final
                             Say p
                             End
    End
  End
Say "Elapsed time:" time('E') "seconds"
Exit

decompositions: Procedure Expose cnt. take spairs
  epairs=.set~new
  Use Arg p
  Parse Var p aa bb
  s=aa+bb
  take=1
  Do xa=2 To s/2
    ya=s-xa
    pp=xa ya
    epairs~put(pp)
    prod=xa*ya
    If cnt.prod=1 Then
      take=0
    End
  return epairs
