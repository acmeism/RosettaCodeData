#  Display the first 25 Ludic numbers
$Ludic[0..24] -join ", "
''

#  Display the count of all Ludic numbers under 1000
$Ludic.Where{ $_ -le 1000 }.Count
''

#  Display the 2000th through the 2005th Ludic number
$Ludic[1999..2004] -join ", "
''

#  Display all Ludic triplets less than 250
$TripletStart = $Ludic.Where{ $_ -lt 244 -and ( $_ + 2 ) -in $Ludic -and ( $_ + 6 ) -in $Ludic }
$TripletStart.ForEach{ $_, ( $_ + 2 ), ( $_ + 6 ) -join ", " }
