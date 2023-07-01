#  For clarity
$Tab = "`t"

#  Create top row
$Tab + ( 1..12 -join $Tab )

#  For each row
ForEach ( $i in 1..12 )
    {
    $(  #  The number in the left column
        $i

        #  An empty slot for the bottom triangle
        @( "" ) * ( $i - 1 )

        #  Calculate the top triangle
        $i..12 | ForEach { $i * $_ }

        #  Combine them all together
        ) -join $Tab
    }
