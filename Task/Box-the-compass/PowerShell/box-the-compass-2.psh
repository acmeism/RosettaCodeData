function Convert-DegreeToDirection ( [double]$Degree, [int]$Points )
    {

    $Directions = @(    'n','n by e','n-ne','ne by n','ne','ne by e','e-ne','e by n',
                        'e','e by s','e-se','se by e','se','se by s','s-se','s by e',
                        's','s by w','s-sw','sw by s','sw','sw by w','w-sw','w by s',
                        'w','w by n','w-nw','nw by w','nw','nw by n','n-nw','n by w',
                        'n'
                    ).Replace( 's', 'south' ).Replace( 'e', 'east' ).Replace( 'n', 'north' ).Replace( 'w', 'west' )

    $Directions[[math]::floor((( $Degree % 360 ) * $Points / 360 + 0.5 )) * 32 / $Points ]
    }

$x = 0.0, 16.87, 16.88, 33.75, 50.62, 50.63, 67.5, 84.37, 84.38, 101.25, 118.12, 118.13, 135.0, 151.87, 151.88, 168.75, 185.62, 185.63, 202.5, 219.37, 219.38, 236.25, 253.12, 253.13, 270.0, 286.87, 286.88, 303.75, 320.62, 320.63, 337.5, 354.37, 354.38


$Values = @()
ForEach ( $Degree in $X ) { $Values += [pscustomobject]@{  Degree = $Degree
                                                               32 = ( Convert-DegreeToDirection -Degree $Degree -Points 32 )
                                                               16 = ( Convert-DegreeToDirection -Degree $Degree -Points 16 )
                                                                8 = ( Convert-DegreeToDirection -Degree $Degree -Points  8 )
                                                                4 = ( Convert-DegreeToDirection -Degree $Degree -Points  4 ) } }
$Values | Format-Table
