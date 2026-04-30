function Get-SumOfMultiples
{
    Param
    (
        [Parameter(
        Position=0)]
        $Cap = 1000,

        [Parameter(
        ValueFromRemainingArguments=$True)]
        $Multiplier = (3,5)
    )

    $Multiples = @()
    $Sum = 0
    $multiplier |
      ForEach-Object {
        For($i = 1; $i -lt $Cap; $i ++)
        {
          If($i % $_ -eq 0)
          {$Multiples += $i}
        }
      }

     $Multiples |
         select -Unique |
         ForEach-Object {
            $Sum += $_
         }
     $Sum
}
