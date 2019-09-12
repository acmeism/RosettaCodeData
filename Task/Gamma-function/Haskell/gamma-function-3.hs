procedure main()
    every write(left(i := !10/10.0,5),gamma(.i))
end

procedure gamma(z)	# Stirling's approximation
    return (2*&pi/z)^0.5 * (z/&e)^z
end
