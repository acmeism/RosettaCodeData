#  Start with the smallest potential square number
$TestSquare = 269696

#  Test if our potential square is a square
#  by testing if the square root of it is an integer
#  Test if the square root is an integer by testing if the remainder
#  of the square root divided by 1 is greater than zero
#  % is the remainder operator
#  -gt is the "greater than" operator

#  While the remainder of the square root divided by one is greater than zero
While ( [Math]::Sqrt( $TestSquare ) % 1 -gt 0 )
    {
    #  Add 100,000 to get the next potential square number
    $TestSquare = $TestSquare + 1000000
    }
#  This will loop until we get a value for $TestSquare that is a square number

#  Caclulate the root
$Root = [Math]::Sqrt( $TestSquare )

#  Display the result and its square
$Root
$TestSquare
