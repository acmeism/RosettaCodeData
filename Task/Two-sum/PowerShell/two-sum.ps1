$numbers = @(0, 2, 11, 19, 90)
$sum = 21

$totals = for ($i = 0; $i -lt $numbers.Count; $i++)
{
    for ($j = $numbers.Count-1; $j -ge 0; $j--)
    {
        [PSCustomObject]@{
            FirstIndex  = $i
            SecondIndex = $j
            TargetSum   = $numbers[$i] + $numbers[$j]
        }
    }
}

$totals | Where-Object TargetSum -EQ $sum |
          Select-Object -First 1 `
                        -Property @{
                                        Name       = "Sum"
                                        Expression = { $_.TargetSum }
                                  },
                                  @{
                                        Name       = "Indices"
                                        Expression = { @($_.FirstIndex, $_.SecondIndex) }
                                  }
