option explicit
const tlcr=3, tlcc=3
const maxdim=15

dim a(15,15)
dim b(15,15)
dim ans0:ans0=chr(27)&"["
dim gen,n

erase a
'glider
a(0,1)=true:a(1,2)=true:a(2,0)=true:a(2,1)=true:a(2,2)=true
'blinker
a(3,13)=true:a(4,13)=true:a(5,13)=true
'beacon
a(11,1)=true:a(11,2)=true: a(12,1)=true:a(12,2)=true
a(13,3)=true:a(13,4)=true: a(14,3)=true:a(14,4)=true

gen=0
doframe

do
  display
  wscript.sleep(100)
  n=newgen
loop until n=0
display

sub cls()  wscript.StdOut.Write ans0 &"2J"&ans0 &"?25l":end sub 'hide cursor too
sub toxy(r,c,s)  wscript.StdOut.Write ans0 & r & ";" & c & "f"  & s :end sub
function iif(a,b,c) if a then iif=b else iif=c end if :end function

sub doframe
  dim r,c,s
	const frame="@"
	cls
	toxy 1,tlcc-1, "Conway's Game of Life"
	toxy tlcr-1,tlcc-1,string(maxdim+3,frame)
	s=frame&space(maxdim+1)&frame
	for r=0 to maxdim
		toxy tlcr+r,tlcc-1,s
	next
	toxy tlcr+maxdim+1,tlcc-1,string(maxdim+3,frame)
end sub

sub display
dim r,c
const pix="#"
for r=0 to maxdim
   for c=0 to maxdim
	   toxy tlcr+r,tlcc+c,iif (a(r,c),pix," ")
	 next
next
toxy tlcr+maxdim+2,tlcc-1,gen & " " & n
toxy tlcr+maxdim+3,tlcc-1,""
gen=gen+1
end sub

function newgen
  dim r,c,cnt,cp,cm,rp,rm
	for r=0 to maxdim
	  for c=0 to maxdim
			cp=(c+1) and maxdim    'wrap around
			cm=(c-1) and maxdim
			rp=(r+1) and maxdim
			rm=(r-1) and maxdim
			cnt=0
			cnt=- a(rp,cp) - a(rp,c) - a(rp,cm)  'true =-1
			cnt=cnt- a(r,cp)-	 a(r,cm)	
			cnt=cnt- a(rm,cp)- a(rm,c) - a(rm,cm)
			
			if a(r,c) then
				b(r,c)=iif (cnt=2 or cnt=3,true,false)
			else
				b(r,c)=iif (cnt=3,true,false)					
			end if
	  next
	next
	for r=0 to maxdim
	  for c=0 to maxdim
		  a(r,c)=b(r,c)
		  newgen=newgen- b(r,c)
	  next
	next
end function
