beer(n)	If n<1 Write "No bottles of beer on the wall... " Quit
	Write !!,n," bottle",$Select(n=1:"",1:"s")," of beer on the wall."
	Write !,n," bottle",$Select(n=1:"",1:"s")," of beer."
	Write !,"Take one down, pass it around."
	Quit

For ii=99:-1:0 Do beer(ii)
