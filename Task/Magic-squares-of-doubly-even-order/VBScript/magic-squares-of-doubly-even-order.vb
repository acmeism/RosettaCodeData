' Magic squares of doubly even order
n=8  'multiple of 4
pattern="1001011001101001"
size=n*n: w=len(size)
mult=n\4  'how many multiples of 4
wscript.echo "Magic square : " & n & " x " & n
i=0
For r=0 To n-1
	l=""
	For c=0 To n-1
		bit=Mid(pattern, c\mult+(r\mult)*4+1, 1)
		If bit="1" Then t=i+1 Else t=size-i
		l=l & Right(Space(w) & t, w) & " "
		i=i+1
	Next 'c
	wscript.echo l
Next 'r
wscript.echo "Magic constant=" & (n*n+1)*n/2
