class ambiguous
	dim sRule

	public property let rule( x )
		sRule = x
	end property
	
	public default function amb(p1, p2)
		amb = eval(sRule)
	end function
end class
