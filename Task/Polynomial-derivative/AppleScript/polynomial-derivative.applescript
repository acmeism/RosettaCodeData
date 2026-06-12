on poly_deriv(l)
	set n to length of l
	repeat with i from 1 to n - 1
		set item i of l to i * (item (i + 1) of l)
	end repeat
	if n > 1 then
		return items 1 thru (n - 1) of l
	else
		return {}
	end if
end poly_deriv

set test_polys to {{5}, {4, -3}, {-1, 6, 5}, {-4, 3, -2, 1}, {1, 1, 0, -1, -1}}

repeat with poly in test_polys
	log poly_deriv(poly)
end repeat
