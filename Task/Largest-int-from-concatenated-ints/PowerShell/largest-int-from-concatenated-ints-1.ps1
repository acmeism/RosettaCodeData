Function Get-LargestConcatenation ( [int[]]$Integers )
    {
    #  Get the length of the largest integer
    $Length = ( $Integers | Sort -Descending | Select -First 1 ).ToString().Length

    #  Convert to an array of strings,
    #  sort by each number repeated Length times and truncated to Length,
    #  and concatenate (join)
    $Concat = ( [string[]]$Integers | Sort { ( $_ * $Length ).Substring( 0, $Length ) } -Descending ) -join ''

    #  Convert to integer (upsizing type if needed)
    try           { $Integer = [ int32]$Concat }
    catch { try   { $Integer = [ int64]$Concat }
            catch { $Integer = [bigint]$Concat } }

    return $Integer
    }
