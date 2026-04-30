on diff_bearing({b1, b2})
	set r to (b2 - b1) mod 360
	if r > 180 then
		r - 360
    else if r < -180 then
		r + 360
	else
		r
	end if
end diff_bearing

set test_bearings to {{20, 45}, {-45, 45}, {-85, 90}, {-95, 90}, {-45, 125}, {-45, 145}, {29.4803, -88.6381}, {-78.3251, -159.036}}

set big_bearings to {{-7.00997423381094E+4, 2.98406743787672E+4}, {-1.65313666629736E+5, 3.36939894517456E+4}, {1174.838051059846, -1.54146664901248E+5}, {6.01757730679555E+4, 4.22130719235437E+4}}

repeat with b in test_bearings & big_bearings
	log diff_bearing(b)
end repeat
