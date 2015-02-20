class
	COUNT_IN_FACTORS

feature
	display_factor(p: INTEGER)
	--- uses the feature factor (Task: prime decomposition)
        require
		p_positive: p>0
	local
		i,j:INTEGER
		factors: ARRAY[INTEGER]
	do
		create factors.make_empty
		from
			i:= 1
		until
			i>p
		loop
			io.put_string ("%N" + i.out + "	")
			factors:= factor(i)
			io.put_string (factors[1].out)
			from
				j:= 2
			until
				j> factors.count
			loop
				io.put_string (" x " + factors[j].out)
				j:= j +1
			end
			i:= i+1
		end
	end
end
