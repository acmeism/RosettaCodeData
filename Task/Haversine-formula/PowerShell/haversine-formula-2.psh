function Get-GreatCircleDistance ( $Coord1, $Coord2 )
    {
    #  Convert decimal degrees to radians
    $Lat1  = $Coord1[0] / 180 * [math]::Pi
    $Long1 = $Coord1[1] / 180 * [math]::Pi
    $Lat2  = $Coord2[0] / 180 * [math]::Pi
    $Long2 = $Coord2[1] / 180 * [math]::Pi

    #  Mean Earth radius (km)
    $R = 6371

    #  Haversine formula
    $ArcLength = 2 * $R *
                    [math]::Asin(
                        [math]::Sqrt(
                            [math]::Sin( ( $Lat1 - $Lat2 ) / 2 ) *
                            [math]::Sin( ( $Lat1 - $Lat2 ) / 2 ) +
                            [math]::Cos( $Lat1 ) *
                            [math]::Cos( $Lat2 ) *
                            [math]::Sin( ( $Long1 - $Long2 ) / 2 ) *
                            [math]::Sin( ( $Long1 - $Long2 ) / 2 ) ) )
    return $ArcLength
    }

$BNA = 36.12,  -86.67
$LAX = 33.94, -118.40

Get-GreatCircleDistance $BNA $LAX
