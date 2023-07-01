all      =.set~new
Call time 'R'
cnt.=0
do a=2 to 100
  do b=a+1 to 100-2
    p=.pairs~new(a,b)
    if p~sum>100 then leave b
    all~put(p)
    prd=p~prod
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
  prod=p~prod
  sProducts.prod+=1
  End

pPairs=.set~new
Do p over sPairs
  prod=p~prod
  If sProducts.prod=1 Then
    pPairs~put(p)
  End
Say "P then has" pPairs~items "possible pairs."

Sums.=0
Do p over pPairs
  sum=p~sum
  Sums.sum+=1
  End

final=.set~new
Do p over pPairs
  sum=p~sum
  If Sums.sum=1 Then
    final~put(p)
  End

si=0
Do p Over final
  si+=1
  sol.si=p
  End
Select
  When final~items=1 Then Say "Answer:" sol.1~string
  When final~items=0 Then Say "No possible answer."
  Otherwise Do;            Say final~items "possible answers:"
                           Do p over final
                             Say p~string
                             End
    End
  End
Say "Elapsed time:" time('E') "seconds"
Exit

decompositions: Procedure Expose cnt. take spairs
  epairs=.set~new
  Use Arg p
  s=p~sum
  take=1
  Do xa=2 To s/2
    ya=s-xa
    pp=.pairs~new(xa,ya)
    epairs~put(pp)
    prod=pp~prod
    If cnt.prod=1 Then
      take=0
    End
  return epairs

::class pairs
::attribute a        -- allow access to attribute
::attribute b        -- allow access to attribute
::attribute sum      -- allow access to attribute
::attribute prod     -- allow access to attribute

-- only the strict equality form is needed for the collection classes,
::method "=="
  expose a b
  use strict arg other
  return a == other~a & b == other~b

-- not needed to make the set difference work, but added for completeness
::method "\=="
  expose a b
  use strict arg other
  return a \== other~a | b \== other~b

::method hashCode
  expose hash
  return hash

::method init        -- create pair, calculate sum, product
                     -- and index (blank delimited values)
  expose hash a b sum prod oid
  use arg a, b
  hash = a~hashCode~bitxor(b~hashCode) -- create hash value
  sum =a+b           -- sum
  prod=a*b           -- product

::method string      -- this creates the string to be shown
  expose a b
  return "[x="||a",y="||b"]"
