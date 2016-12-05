function Test-Order ([int[]]$ReferenceArray, [int[]]$DifferenceArray)
{
    for ($i = 0; $i -lt $ReferenceArray.Count; $i++)
    {
        if ($ReferenceArray[$i] -lt $DifferenceArray[$i])
        {
            return $true
        }
        elseif ($ReferenceArray[$i] -gt $DifferenceArray[$i])
        {
            return $false
        }
    }

    return ($ReferenceArray.Count -lt $DifferenceArray.Count) -or (Compare-Object $ReferenceArray $DifferenceArray) -eq $null
}
