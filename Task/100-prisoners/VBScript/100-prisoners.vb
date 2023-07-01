option explicit
const npris=100
const ntries=50
const ntests=1000.
dim drawer(100),opened(100),i
for i=1 to npris: drawer(i)=i:next
shuffle drawer
wscript.echo rf(tests(false)/ntests*100,10," ")  &" % success for random"
wscript.echo rf(tests(true) /ntests*100,10," ")  &" % success for optimal strategy"

function rf(v,n,s) rf=right(string(n,s)& v,n):end function

sub shuffle(d) 'knut's shuffle
dim i,j,t
randomize timer
for i=1 to npris
   j=int(rnd()*i+1)
   t=d(i):d(i)=d(j):d(j)=t
next
end sub

function tests(strat)
dim cntp,i,j
tests=0
for i=1 to ntests
  shuffle drawer
  cntp=0
  if strat then
      for j=1 to npris
	if not trystrat(j) then exit for
      next
  else		
     for j=1 to npris
       if not tryrand(j) then exit for
     next
  end if
  if j>=npris then tests=tests+1
next
end function
	
function tryrand(pris)
  dim i,r
	erase opened
  for i=1 to ntries
    do
      r=int(rnd*npris+1)
    loop until opened(r)=false
    opened(r)=true
    if drawer(r)= pris then tryrand=true : exit function
  next
  tryrand=false
end function

function trystrat(pris)
  dim i,r
  r=pris
  for i=1 to ntries
    if drawer(r)= pris then trystrat=true	:exit function
    r=drawer(r)
  next
  trystrat=false
end function	
