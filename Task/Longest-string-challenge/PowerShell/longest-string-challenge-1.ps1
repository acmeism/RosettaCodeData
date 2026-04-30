#  Get-Content strips out any type of line break and creates an array of strings
#  We'll join them back together and put a specific type of line break back in
$File = ( Get-Content C:\Test\File.txt ) -join "`n"

$LongestString = $LongestStrings = ''

#  While the file string still still exists
While ( $File )
    {
    #  Set the String to the first string and File to any remaining strings
    $String, $File = $File.Split( "`n", 2 )

    #  Strip off characters until one or both strings are zero length
    $A = $LongestString
    $B = $String
    While ( $A -and $B )
        {
        $A = $A.Substring( 1 )
        $B = $B.Substring( 1 )
        }

    #  If A is zero length...
    If ( -not $A )
        {
        #  If $B is not zero length (and therefore String is longer than LongestString)...
        If ( $B )
            {
            $LongestString = $String
            $LongestStrings = $String
            }
        #  Else ($B is also zero length, and therefore String is the same length as LongestString)...
        Else
            {
            $LongestStrings = $LongestStrings, $String -join "`n"
            }
        }
    }

#  Output longest strings
$LongestStrings.Split( "`n" )
