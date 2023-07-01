def getDifference(b1, b2)
	r = (b2 - b1) % 360.0
	# Ruby modulus has same sign as divisor, which is positive here,
	# so no need to consider negative case
	if r >= 180.0
		r -= 360.0
	end
	return r
end

if __FILE__ == $PROGRAM_NAME
	puts "Input in -180 to +180 range"
	puts getDifference(20.0, 45.0)
	puts getDifference(-45.0, 45.0)
	puts getDifference(-85.0, 90.0)
	puts getDifference(-95.0, 90.0)
	puts getDifference(-45.0, 125.0)
	puts getDifference(-45.0, 145.0)
	puts getDifference(-45.0, 125.0)
	puts getDifference(-45.0, 145.0)
	puts getDifference(29.4803, -88.6381)
	puts getDifference(-78.3251, -159.036)

	puts "Input in wider range"
	puts getDifference(-70099.74233810938, 29840.67437876723)
	puts getDifference(-165313.6666297357, 33693.9894517456)
	puts getDifference(1174.8380510598456, -154146.66490124757)
	puts getDifference(60175.77306795546, 42213.07192354373)
end
