$MinR2 = 10 * 10
$MaxR2 = 15 * 15

$Points = @{}

While ( $Points.Count -lt 100 )
    {
    $X = Get-Random -Minimum -16 -Maximum 17
    $Y = Get-Random -Minimum -16 -Maximum 17
    $R2 = $X * $X + $Y * $Y

    If ( $R2 -ge $MinR2 -and $R2 -le $MaxR2 -and "$X,$Y" -notin $Points.Keys )
        {
        $Points += @{ "$X,$Y" = 1 }
        }
    }

ForEach ( $Y in -16..16 ) { ( -16..16 | ForEach { ( " ", "*" )[[int]$Points["$_,$Y"]] } ) -join '' }
