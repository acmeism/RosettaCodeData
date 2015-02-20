class
	CATALAN_NUMBERS
feature

	cat_num(n:INTEGER): DOUBLE
	require
		n_not_negative:n>= 0
	local
		s,t: DOUBLE
	do
	if n=0 then
		Result:= 1.0
	else
		t:= 4*n.to_double-2
		s:= n.to_double+1
		Result:= t/s*cat_num(n-1)
	end
	end
end
