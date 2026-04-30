function IsAscending ( [string[]]$Array ) { ( 0..( $Array.Count - 2 ) ).Where{ $Array[$_] -le $Array[$_+1] }.Count -eq $Array.Count - 1 }
function IsEqual     ( [string[]]$Array ) { ( 0..( $Array.Count - 2 ) ).Where{ $Array[$_] -eq $Array[$_+1] }.Count -eq $Array.Count - 1 }

IsAscending 'A', 'B', 'B', 'C'
IsAscending 'A', 'C', 'B', 'C'
IsAscending 'A', 'A', 'A', 'A'

IsEqual     'A', 'B', 'B', 'C'
IsEqual     'A', 'C', 'B', 'C'
IsEqual     'A', 'A', 'A', 'A'
