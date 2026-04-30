$Colors = 'red', 'white','blue'

#  Select 10 random colors
$RandomBalls = 1..10 | ForEach { $Colors | Get-Random }

#  Ensure we aren't finished before we start. For some reason. It's in the task requirements.
While ( $RandomBalls -eq $RandomBalls | Sort { $Colors.IndexOf( $_ ) } )
    { $RandomBalls = 1..10 | ForEach { $Colors | Get-Random } }

#  Sort the colors
$SortedBalls = $RandomBalls | Sort { $Colors.IndexOf( $_ ) }

#  Display the results
$RandomBalls
''
$SortedBalls
