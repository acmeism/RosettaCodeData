class
	SUM_MULTIPLES_OF_THREE_AND_FIVE

feature
	is_multiple(x,y: INTEGER):BOOLEAN
	local
	do
		RESULT:= x\\y=0
	end

	sum_multiples(n: INTEGER): INTEGER
	local
		i,sum: INTEGER
 	do
 		from
 			i:= 1
 		until
 			i=n
 		loop
 			if is_multiple(i,3) or is_multiple(i,5) then
 				sum:= sum+i
 			end
 			i:= i+1
 		end
 		Result:= sum
 	end
end
