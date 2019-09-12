to sieve(N)
	script
		on array()
			set L to {}
			
			repeat with i from 1 to N
				set end of L to i
			end repeat
			
			L
		end array
	end script
	
	set L to result's array()
	set item 1 of L to false
	
	repeat with x in L
		repeat with y in L
			try
				if (x < y ^ 2) then exit repeat
				if (x mod y = 0) then
					set x's contents to false
					exit repeat
				end if
			end try
		end repeat
	end repeat
	
	numbers in L
end sieve


sieve(1000)
