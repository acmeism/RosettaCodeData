function Get-HarshadNumbers
    {
    <#
    .SYNOPSIS
    Returns numbers in the Harshad or Niven series.

    .DESCRIPTION
    Returns all integers in the given range that are evenly divisible by the sum of their digits
    in ascending order.

    .PARAMETER Minimum
    Lower bound of the range to search for Harshad numbers. Defaults to 1.

    .PARAMETER Maximum
    Upper bound of the range to search for Harshad numbers. Defaults to 2,147,483,647

    .PARAMETER Count
    Maximum number of Harshad numbers to return.
    #>

    [cmdletbinding()]
    Param (
        [int]$Minimum = 1,
        [int]$Maximum = [int]::MaxValue,
        [int]$Count )

    #  Skip any non-positive numbers in the specified range
    $Minimum = [math]::Max( 1, $Minimum )

    #  If the adjusted range has any numbers in it...
    If ( $Maximum -ge $Minimum )
        {
        #  If a count was specified, build a parameter for the Select statement to kill the pipeline when the count is achieved.
        If ( $Count ) { $SelectParam = @{ First = $Count } }
        Else          { $SelectParam = @{} }

        #  For each number in the range, test the remainder of it divided it by iteself (converted to a string,
        #  then a character array, then a string array, then an integer array, then summed).
        $Minimum..$Maximum | Where { $_ % ( [int[]][string[]][char[]][string]$_ | Measure -Sum ).Sum -eq 0 } | Select @SelectParam
        }
    }
