$current = $list.First

while(-not ($current -eq $null))
{
   If($current.Value.X -eq 105)
   {
       $list.AddAfter($current, [PSCustomObject]@{ID=345;X=345;Y=345}) | Out-Null
       break
   }

   $current = $current.Next
}

$list
