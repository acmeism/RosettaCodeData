function Test-Palindrome ( [String]$String )
    {
    #  Default value
    $IsPalindrome = $True

    #  For each position in the string from the start to the middle
    ForEach ( $Index in ( 0..($String.Length -shr 1 ) ) )
        {
        #  Check if the character at this position matches the corresponding character at the other end
        $IsPalindrome = $IsPalindrome -and $String[$Index] -eq $String[$String.Length - $Index - 1]
        }

    return $IsPalindrome
    }

function Get-LychrelNumbers ( [int]$Upto, [int]$IterationLimit = 500 )
    {
    #  Initialize empty collections
    #  (More typically, PowerShell will use Arrays, but we are using
    #   ArrayLists here to optimize speed and memory usage.)
    $Seeds       = New-Object System.Collections.ArrayList
    $Related     = New-Object System.Collections.ArrayList
    $Palindromes = New-Object System.Collections.ArrayList

    #  For each integer in the test range...
    ForEach ( $N in [bigint]1..[bigint]$Upto )
        {
        #  If N was already identified as a related Lychrel in another
        #  Lychrel series, we don't need to test it
        If ( $N -notin $Related )
            {
            #  Default value
            $IsRelated = $False

            #  Initialize empty collection
            $NSeries = New-Object System.Collections.ArrayList

            #  Starting at N
            $S = $N

            #  Convert S to a string for testing and processing
            $SString = $S.ToString()

            #  For each iteration up to the maximum...
            #  (Generally we would not use ForEach with Break for a loop with
            #   these requirements, but this script is optimized for speed
            #   and ForEach ( $x in $y ) is the fastest loop in PowerShell.)
            ForEach ( $i in 1..$IterationLimit )
                {
                #  Add the reverse of S to S
                $S += [bigint]($SString[($SString.Length)..0] -join '' )

                #  If S appears in the series of a smaller seed Lychrel
                If ( $S -in $Related )
                    {
                    #  S is a related Lychrel; exit processing loop
                    $IsRelated = $True
                    Break
                    }

                #  Convert S to a string for testing and processing
                $SString = $S.ToString()

                If ( Test-Palindrome $SString )
                    {
                    Break
                    }

                #  Add S to the series we are testing
                #  (for possible inclusion as a related number if N turns out to be a seed)
                $NSeries.Add( $S )
                }

            #  If series did not terminate before the iteration limit...
            #  (Including if we stopped early because it join up with an earlier non-terminating series)
            If ( $IsRelated -or $i -eq $IterationLimit )
                {
                #  Add everything in the series above N to the list of related Lychrel numbers
                $Related.AddRange( $NSeries )

                #  If N is a related Lychrel number, add it to the list
                If ( $IsRelated         ) { $Related.    Add( $N ) }

                #  Otherwise add it to the list of Seed Lychrel numbers
                Else                      { $Seeds.      Add( $N ) }

                #  If N is a palindrome, add it to the list of palindrome Lychrel numbers
                If ( Test-Palindrome $N ) { $Palindromes.Add( $N ) }
                }
            }
        }

    #  Convert the various arraylists of big integers to arrays of integers and assign
    #  them as properties of a custom return object. Filter out those Related Lychrel
    #  numbers which exceed our search range.
    $LychrelNumbers = [pscustomobject]@{
            Seeds       = [int[]]$Seeds
            Related     = [int[]]$Related.Where{ $_ -le $Upto }
            Palindromes = [int[]]$Palindromes }

    return $LychrelNumbers
    }
