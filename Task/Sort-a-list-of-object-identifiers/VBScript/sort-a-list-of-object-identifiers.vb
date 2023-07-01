' Sort a list of object identifiers - VBScript
function myCompare(x,y)
	dim i,b
	sx=split(x,".")
	sy=split(y,".")
	b=false
	for i=0 to ubound(sx)
		if i > ubound(sy) then b=true: exit for
		select case sgn(int(sx(i))-int(sy(i)))
			case  1: b=true:  exit for
			case -1: b=false: exit for
		end select
	next
	myCompare=b
end function

function bubbleSort(t)
	dim i,n
	n=ubound(t)
	do
		changed=false
		n= n-1
		for i=0 to n
			if myCompare(t(i),t(i+1)) then
				tmp=t(i): t(i)=t(i+1): t(i+1)=tmp
				changed=true
			end if
		next
	loop until not changed
	bubbleSort=t
end function

a=array( _
	"1.3.6.1.4.1.11.2.17.19.3.4.0.10", _
	"1.3.6.1.4.1.11.2.17.5.2.0.79", _
	"1.3.6.1.4.1.11.2.17.19.3.4.0.4", _
	"1.3.6.1.4.1.11150.3.4.0.1", _
	"1.3.6.1.4.1.11.2.17.19.3.4.0.1", _
	"1.3.6.1.4.1.11150.3.4.0")
bubbleSort a
wscript.echo join(a,vbCrlf)
