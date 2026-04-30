$list = New-Object -TypeName System.Collections.ArrayList -ArgumentList 1,2,3

# or...

$list = [System.Collections.ArrayList]@(1,2,3)


$list.Add(4) | Out-Null
$list.RemoveAt(2)
