option explicit

class List
	private theList
	private nOccupiable
	private nTop
	
	sub class_initialize
		nTop = 0
		nOccupiable = 100
		redim theList( nOccupiable )
	end sub
	
	public sub store( x )
		if nTop >= nOccupiable then
			nOccupiable = nOccupiable + 100
			redim preserve theList( nOccupiable )
		end if
		theList( nTop ) = x
		nTop = nTop + 1
	end sub
	
	public function recall( n )
		if n >= 0 and n <= nOccupiable then
			recall = theList( n )
		else
			err.raise vbObjectError + 1000,,"Recall bounds error"
		end if
	end function
	
	public sub replace( n, x )
		if n >= 0 and n <= nOccupiable then
			theList( n )  = x
		else
			err.raise vbObjectError + 1001,,"Replace bounds error"
		end if
	end sub
	
	public property get listCount
		listCount = nTop
	end property
		
end class

function halve( n )
	halve = int( n / 2 )
end function

function twice( n )
	twice = int( n * 2 )
end function

function iseven( n )
	iseven = ( ( n mod 2 ) = 0 )
end function


function multiply( n1, n2 )
	dim LL
	set LL = new List

	dim RR
	set RR = new List

	LL.store n1
	RR.store n2
	
	do while n1 <> 1
		n1 = halve( n1 )
		LL.store n1
		n2 = twice( n2 )
		RR.store n2
	loop
	
	dim i
	for i = 0 to LL.listCount
		if iseven( LL.recall( i ) ) then
			RR.replace i, 0
		end if
	next

	dim total
	total = 0
	for i = 0 to RR.listCount
		total = total + RR.recall( i )
	next
	
	multiply = total
end function
