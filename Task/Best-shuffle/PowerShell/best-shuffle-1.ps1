#  Calculate best possible shuffle score for a given string
#  (Split out into separate function so we can use it separately in our output)
function Get-BestScore ( [string]$String )
    {
    #  Convert to array of characters, group identical characters,
    #  sort by frequecy, get size of first group
    $MostRepeats = $String.ToCharArray() |
                    Group |
                    Sort Count -Descending |
                    Select -First 1 -ExpandProperty Count

    #  Return count of most repeated character minus all other characters (math simplified)
    return [math]::Max( 0, 2 * $MostRepeats - $String.Length )
    }

function Get-BestShuffle ( [string]$String )
    {
    #  Convert to arrays of characters, one for comparison, one for manipulation
    $S1 = $String.ToCharArray()
    $S2 = $String.ToCharArray()

    #  Calculate best possible score as our goal
    $BestScore = Get-BestScore $String

    #  Unshuffled string has score equal to number of characters
    $Length = $String.Length
    $Score = $Length

    #  While still striving for perfection...
    While ( $Score -gt $BestScore )
        {
        #  For each character
        ForEach ( $i in 0..($Length-1) )
            {
            #  If the shuffled character still matches the original character...
            If ( $S1[$i] -eq $S2[$i] )
                {
                #  Swap it with a random character
                #  (Random character $j may be the same as or may even be
                #   character $i. The minor impact on speed was traded for
                #   a simple solution to guarantee randomness.)
                $j = Get-Random -Maximum $Length
                $S2[$i], $S2[$j] = $S2[$j], $S2[$i]
                }
            }
        #  Count the number of indexes where the two arrays match
        $Score = ( 0..($Length-1) ).Where({ $S1[$_] -eq $S2[$_] }).Count
        }
    #  Put it back into a string
    $Shuffle = ( [string[]]$S2 -join '' )
    return $Shuffle
    }
