input | parse "{a} {b}" | first | values | into int | do {|a b|
	{
		Sum: ($a + $b)
		Difference: ($a - $b)
		Product: ($a * $b)
		Quotient: ($a // $b)
		Remainder: ($a mod $b)
		Exponent: ($a ** $b)
	}
} $in.0 $in.1
