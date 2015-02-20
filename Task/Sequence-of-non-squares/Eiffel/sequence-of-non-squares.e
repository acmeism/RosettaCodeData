class
	APPLICATION
inherit
	ARGUMENTS
create
    make
feature
	make
	do
		non_square(22)
	end

	non_square(n:INTEGER)
	require
		n_positive: n>=1
	local
		i: INTEGER
		non_sq, part: REAL_64
		math: DOUBLE_MATH
		square: BOOLEAN
	do
		create math
		from
			i:= 1
		until
			i> n
		loop
			part:=(0.5+math.sqrt (i.to_double))
			non_sq:= i+part.floor
			io.put_string (non_sq.out + " ")
			if math.sqrt (non_sq)-math.sqrt (non_sq).floor=0 then
				square:= True
			end
			i:= i+1
		end
		if square=  TRUE then
			io.put_string ("%NThere are squares for n equal to "+ n.out + "."  )
		else
			io.put_string ("%NThere are no squares for n equal to "+ n.out + ".")
		end
	end
end
