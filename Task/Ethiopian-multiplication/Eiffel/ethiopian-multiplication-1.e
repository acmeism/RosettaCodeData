class
	ETHIOPIAN_MULTIPLICATION
feature{NONE}
	double_int(n: INTEGER): INTEGER
	do
		Result:= n*2
	end

	halve_int(n: INTEGER) : INTEGER
	do
		Result:= n//2
	end

	even_int(n: INTEGER): BOOLEAN
 	do
 		Result:= n\\2=0
 	end
feature
 	ethiopian_mult(a,b: INTEGER): INTEGER
 	require
 		a_positive: a>0
 		b_positive: b>0
 	local
 		new_a, new_b: INTEGER
 	do
 		new_a:= a
 		new_b:= b
 		from
 		until
 			new_a<=0
 		loop
 			if even_int(new_a)= FALSE then
 				Result:= Result+new_b
 			end
 			new_a:= halve_int(new_a)
 			new_b:= double_int(new_b)
 		end
 	ensure
 		Result_correct: Result= a*b
 	end
end
