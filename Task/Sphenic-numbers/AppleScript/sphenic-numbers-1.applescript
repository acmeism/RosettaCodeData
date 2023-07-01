on sieveOfEratosthenes(limit)
    set mv to missing value
    if (limit < 2) then return {}
    script o
        property numberList : prefabList(limit, mv)
    end script
    -- Write in 2, 3, and numbers which aren't their multiples.
    set o's numberList's second item to 2
    if (limit > 2) then set o's numberList's third item to 3
    repeat with n from 5 to limit by 6
        set o's numberList's item n to n
        tell (n + 2) to if (it ≤ limit) then set o's numberList's item it to it
    end repeat
    -- "Cross out" slots for multiples of written-in numbers not then crossed out themselves.
    repeat with n from 5 to ((limit ^ 0.5) div 1) by 6
        repeat 2 times
            if (o's numberList's item n = n) then
                repeat with multiple from (n * n) to limit by n
                    set item multiple of o's numberList to mv
                end repeat
            end if
            set n to n + 2
        end repeat
    end repeat
    return o's numberList's numbers
end sieveOfEratosthenes

on prefabList(|size|, filler)
	if (|size| < 1) then return {}
	script o
		property lst : {filler}
	end script
	
	set |count| to 1
	repeat until (|count| + |count| > |size|)
		set o's lst to o's lst & o's lst
		set |count| to |count| + |count|
	end repeat
	if (|count| < |size|) then set o's lst to o's lst & o's lst's items 1 thru (|size| - |count|)
	return o's lst
end prefabList

on getSphenicsBelow(limit)
	set limit to limit - 1
	script o
		property primes : sieveOfEratosthenes(limit div (2 * 3))
		property sphenics : prefabList(limit, missing value)
	end script
	
	repeat with a from 3 to (count o's primes)
		set x to o's primes's item a
		repeat with b from 2 to (a - 1)
			set y to x * (o's primes's item b)
			if (y ≥ limit) then exit repeat
			repeat with c from 1 to (b - 1)
				set z to y * (o's primes's item c)
				if (z > limit) then exit repeat
				set o's sphenics's item z to z
			end repeat
		end repeat
	end repeat
	return (o's sphenics's numbers)
end getSphenicsBelow

on join(lst, delim)
	set astid to AppleScript's text item delimiters
	set AppleScript's text item delimiters to delim
	set txt to lst as text
	set AppleScript's text item delimiters to astid
	return txt
end join

on primeFactors(n)
	set output to {}
	if (n < 2) then return output
	set limit to (n ^ 0.5) div 1
	set f to 2
	repeat until (f > limit)
		if (n mod f = 0) then
			set end of output to f
			set n to n div f
			repeat while (n mod f = 0)
				set n to n div f
			end repeat
			if (limit > n) then set limit to n
		end if
		set f to f + 1
	end repeat
	if (limit < n) then set end of output to n
	return output
end primeFactors

on task()
	script o
		property sphenics : getSphenicsBelow(1000000)
	end script
	set {t1, t2, t3, t4, t5} to {{}, {}, count o's sphenics, 0, o's sphenics's 200000th item}
	repeat with i from 1 to (t3 - 2)
		set s to o's sphenics's item i
		if (s < 1000) then set end of t1 to text -4 thru -1 of ("   " & s)
		set s2 to o's sphenics's item (i + 2)
		if (s2 - s = 2) then
			if (s2 < 10000) then ¬
				set end of t2 to "{" & join(o's sphenics's items i thru (i + 2), ", ") & "}"
			set t4 to t4 + 1
			if (t4 = 5000) then ¬
				set t6 to "{" & join(o's sphenics's items i thru (i + 2), ", ") & "}"
		end if
	end repeat
	
	set output to {"Sphenic numbers < 1,000:"}
	repeat with i from 1 to 135 by 15
		set end of output to join(t1's items i thru (i + 14), "")
	end repeat
	set end of output to linefeed & "Sphenic triplets < 10,000:"
	repeat with i from 1 to 21 by 3
		set end of output to join(t2's items i thru (i + 2), " ")
	end repeat
	set end of output to linefeed & "There are " & t3 & " sphenic numbers < 1,000,000"
	set end of output to "There are " & t4 & " sphenic triplets < 1,000,000"
	set end of output to "The 200,000th sphenic number is " & t5 & ¬
		(" (" & join(primeFactors(t5), " * ") & ")")
	set end of output to "The 5,000th sphenic triplet is " & t6
	
	return join(output, linefeed)
end task

task()
