include std/utils.e

function fb( atom n )
	sequence fb
	if remainder( n, 15 ) = 0 then
		fb = "FizzBuzz"
	elsif remainder( n, 5 ) = 0 then
		fb = "Fizz"
	elsif remainder( n, 3 ) = 0 then
		fb = "Buzz"
	else
		fb = sprintf( "%d", n )
	end if
	return fb
end function

function fb2( atom n )
	return iif( remainder(n, 15) = 0, "FizzBuzz",
		iif( remainder( n, 5 ) = 0, "Fizz",
		iif( remainder( n, 3) = 0, "Buzz", sprintf( "%d", n ) ) ) )
end function

for i = 1 to 30 do
	printf( 1, "%s ", { fb( i ) } )
end for

puts( 1, "\n" )

for i = 1 to 30 do
	printf( 1, "%s ", { fb2( i ) } )
end for

puts( 1, "\n" )
