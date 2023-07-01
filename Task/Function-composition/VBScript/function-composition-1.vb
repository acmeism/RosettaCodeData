option explicit
class closure

	private composition
	
	sub compose( f1, f2 )
		composition = f2 & "(" & f1 & "(p1))"
	end sub
	
	public default function apply( p1 )
		apply = eval( composition )
	end function
	
	public property get formula
		formula = composition
	end property
	
end class
