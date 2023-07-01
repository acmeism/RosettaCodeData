function Add-SEDOLCheckDigit
    {
    Param ( #  Validate input as six-digit SEDOL number
            [ValidatePattern( "^[0123456789bcdfghjklmnpqrstvwxyz]{6}$" )]
            [parameter ( Mandatory = $True ) ]
            [string]
            $SixDigitSEDOL )

    #  Convert to array of single character strings, using type char as an intermediary
    $SEDOL = [string[]][char[]]$SixDigitSEDOL

    #  Define place weights
    $Weight = @( 1, 3, 1, 7, 3, 9 )

    #  Define character values (implicit in 0-based location within string)
    $Characters = "0123456789abcdefghijklmnopqrstuvwxyz"

    $CheckSum = 0

    #  For each digit, multiply the character value by the weight and add to check sum
    0..5 | ForEach { $CheckSum += $Characters.IndexOf( $SEDOL[$_].ToLower() ) * $Weight[$_] }

    #  Derive the check digit from the partial check sum
    $CheckDigit = ( 10 - $CheckSum % 10 ) % 10

    #  Return concatenated result
    return ( $SixDigitSEDOL + $CheckDigit )
    }

#  Test
$List = @(
    "710889"
    "B0YBKJ"
    "406566"
    "B0YBLH"
    "228276"
    "B0YBKL"
    "557910"
    "B0YBKR"
    "585284"
    "B0YBKT"
    "B00030"
    )

ForEach ( $PartialSEDOL in $List )
    {
    Add-SEDOLCheckDigit -SixDigitSEDOL $PartialSEDOL
    }
