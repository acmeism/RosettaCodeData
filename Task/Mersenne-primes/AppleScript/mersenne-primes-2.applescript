on isPrime(n)
    if (n < 4) then return (n > 1)
    if ((n mod 2 is 0) or (n mod 3 is 0)) then return false
    set {i, max} to {5, (n ^ 0.5) div 1}
    repeat until (i > max)
        if ((n mod i is 0) or (n mod (i + 2) is 0)) then return false
        set i to i + 6
    end repeat
    return true
end isPrime

on join(lst, delim)
    set astid to AppleScript's text item delimiters
    set AppleScript's text item delimiters to delim
    set txt to lst as text
    set AppleScript's text item delimiters to astid
    return txt
end join

on mersennePrimes()
	set output to {"Mersenne primes within AppleScript's number precision:"}
	-- Special-case 2 ^ 2 - 1.
	set end of output to "2 ^ 2 - 1 = 3"
	set p to 1 -- Otherwise test odd-numbered powers of 2.
	try -- Survive the "numeric operation too large" error when it occurs.
		repeat
			set p to p + 2
			if ((isPrime(p)) and (isPrime(2 ^ p - 1))) then ¬
				set end of output to "2 ^ " & p & " - 1 = " & (2 ^ p div 1 - 1)
		end repeat
	end try
	
	return join(output, linefeed)
end mersennePrimes

mersennePrimes()
