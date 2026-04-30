class accumulator
	dim A
	public default function acc(x)
		A = A + x
		acc = A
	end function
	public property get accum
		accum = A
	end property
end class
