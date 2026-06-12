on isPrime(integ)
	set isComposite to ""
	if (integ / 2) = (integ / 2 div 1) then
		log integ & " is composite because 2 is a factor" as string --buttons {"OK", "Cancel"} default button 1 cancel button 2
		
	else
		set x to 2
		set sqrtOfInteg to integ ^ 0.5
		repeat until x = integ ^ 0.5 + 1 as integer
			if (integ / x) = integ / x div 1 then
				log integ & " is composite because " & x & " & " & (integ / x div 1) & " are factors" as string --buttons {"OK", "Cancel"} default button 1 cancel button 2
				set isComposite to 1
				set x to x + 1
			else
				
				set x to x + 1
			end if
			
			
			
		end repeat
		log integ & " is prime" as string --buttons {"OK", "Cancel"} default button 1 cancel button 2
		if isComposite = 1 then
			log integ & "is composite"
		else
			display dialog integ
		end if
	end if
	
end isPrime
set x to 2
repeat
	isPrime(((2 ^ x) - 1) div 1)
	set x to x + 1
end repeat
