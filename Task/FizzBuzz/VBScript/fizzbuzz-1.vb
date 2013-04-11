'using the IF/ELSEIF ladder
function fb( n )
	if n mod 15 = 0 then
		fb = "FizzBuzz"
	elseif n mod 5 = 0 then
		fb = "Fizz"
	elseif n mod 3 = 0 then
		fb = "Buzz"
	else
		fb = n
	end if
end function

'the Mexican IF
function eef( b, p1, p2 )
	if b then
		eef = p1
	else
		eef = p2
	end if
end function

'using the Mexican IF
function fb2( n )
	fb2 = eef( n mod 15 = 0, "FizzBuzz", eef( n mod 5 = 0, "Fizz", eef( n mod 3 = 0, "Buzz", n ) ) )
end function
