class callback
	dim sRule

	public property let rule( x )
		sRule = x
	end property
	
	public default function applyTo(a)
		dim p1
		for i = lbound( a ) to ubound( a )
			p1 = a( i )
			a( i ) = eval( sRule )
		next
		applyTo = a
	end function
end class
