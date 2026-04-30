function New-ThueMorse ( $Digits )
    {
    #  Start with seed 0
    $ThueMorse = "0"

    #  Decrement digits remaining
    $Digits--

    #  While we still have digits to calculate...
    While ( $Digits -gt 0 )
        {
        #  Number of digits we'll get this loop (what we still need up to the maximum available), corrected to 0 base
        $LastDigit = [math]::Min( $ThueMorse.Length, $Digits ) - 1

        #  Loop through each digit
        ForEach ( $i in 0..$LastDigit )
            {
            #  Append the twos complement
            $ThueMorse += ( 1 - $ThueMorse.Substring( $i, 1 ) )
            }

        #  Calculate the number of digits still remaining
        $Digits = $Digits - $LastDigit - 1
        }

    return $ThueMorse
    }

New-ThueMorse 5
New-ThueMorse 16
New-ThueMorse 73
