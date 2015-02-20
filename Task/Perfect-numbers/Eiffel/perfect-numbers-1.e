class
	PERFECT_NUMBERS
feature
	perfect(n:INTEGER):BOOLEAN
	require
		n_positive: n>0
	local
		sum, i: INTEGER
	do
		from
			i:=1
		until
			i=n
		loop
			if n\\i=0 then
				sum:=sum+i
			end
			i:= i+1
		end
		if sum= n then
			RESULT:= TRUE
		end
	end
end
