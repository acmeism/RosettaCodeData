function Get-TimesTable ( [int]$Size )
    {
    #  For clarity
    $Tab = "`t"

    #  Create top row
    $Tab + ( 1..$Size -join $Tab )

    #  For each row
    ForEach ( $i in 1..$Size )
        {
        $(  #  The number in the left column
            $i

            #  An empty slot for the bottom triangle
            @( "" ) * ( $i - 1 )

            #  Calculate the top triangle
            $i..$Size | ForEach { $i * $_ }

         #  Combine them all together (and send them to the out put stream, which in PowerShell implicityly returns them)
         ) -join $Tab
        }
    }

Get-TimesTable 18
