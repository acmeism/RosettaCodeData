class
	PRIME_DECOMPOSITION
feature
	factor(p: INTEGER): ARRAY[INTEGER]
	require
		p_positive: p>0
        local
		div,i: INTEGER
		next:INTEGER
		rest: INTEGER
		d: ARRAY[INTEGER]
	do
		create d.make_empty
		if p= 1 then
			d.force (1, 1)
			Result:= d
		end
		div:= 2
		next:= 3
		rest:=p
		from
		i:=1
		until rest=1
		loop
			from
			until rest\\div/=0
			loop
				d.force( div, i)
				rest := (rest/div).floor
				i:= i+1
			end
			div := next
			next:= next+2
		end
		Result:= d
	end
end
