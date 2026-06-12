on task()
	script o
		property output : {}
	end script
	
	repeat with a from 2 to 5
		repeat with b from 2 to 5
			set n to a ^ b as integer
			if n is not in o's output then
				set flag to false -- is n less than some item in output?
				repeat with i from 1 to count o's output
					if n < item i of o's output then
						set flag to true -- n is less than some item already in output
						exit repeat
					end if
				end repeat
				if flag then
					if i = 1 then
						set beginning of o's output to n
					else
						set o's output to items 1 thru (i - 1) of o's output & {n} & items i thru -1 of o's output
					end if
				else -- put n at end of list
					set end of o's output to n
				end if
			end if
		end repeat
	end repeat
	
	return o's output's integers
end task

task()
