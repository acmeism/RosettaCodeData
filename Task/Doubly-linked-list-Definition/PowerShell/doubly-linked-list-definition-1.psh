$list = New-Object -TypeName 'Collections.Generic.LinkedList[PSCustomObject]'

for($i=1; $i -lt 10; $i++)
{
   $list.AddLast([PSCustomObject]@{ID=$i; X=100+$i;Y=200+$i}) | Out-Null
}

$list
