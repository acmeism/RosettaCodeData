function Test-LuhnNumber
{
  <#
    .SYNOPSIS
        Tests validity of credit card numbers.
    .DESCRIPTION
        Tests validity of credit card numbers using the Luhn test.
    .PARAMETER Number
        The number must be 11 or 16 digits.
    .EXAMPLE
        Test-LuhnNumber 49927398716
    .EXAMPLE
        [int64[]]$numbers = 49927398716, 49927398717, 1234567812345678, 1234567812345670
        C:\PS>$numbers | ForEach-Object {
                  "{0,-17}: {1}" -f $_,"$(if(Test-LuhnNumber $_) {'Is valid.'} else {'Is not valid.'})"
              }
  #>
    [CmdletBinding()]
    [OutputType([bool])]
    Param
    (
        [Parameter(Mandatory=$true,
                   Position=0)]
        [ValidateScript({$_.Length -eq 11 -or $_.Length -eq 16})]
        [ValidatePattern("^\d+$")]
        [string]
        $Number
    )

    $digits = ([Regex]::Matches($Number,'.','RightToLeft')).Value

    $digits |
        ForEach-Object `
               -Begin   {$i = 1} `
               -Process {if ($i++ % 2) {$_}} |
        ForEach-Object `
               -Begin   {$sumOdds = 0} `
               -Process {$sumOdds += [Char]::GetNumericValue($_)}
    $digits |
        ForEach-Object `
               -Begin   {$i = 0} `
               -Process {if ($i++ % 2) {$_}} |
        ForEach-Object `
               -Process {[Char]::GetNumericValue($_) * 2} |
        ForEach-Object `
               -Begin   {$sumEvens = 0} `
               -Process {
                            $_number = $_.ToString()
                            if ($_number.Length -eq 1)
                            {
                                $sumEvens += [Char]::GetNumericValue($_number)
                            }
                            elseif ($_number.Length -eq 2)
                            {
                                $sumEvens += [Char]::GetNumericValue($_number[0]) + [Char]::GetNumericValue($_number[1])
                            }
                        }

    ($sumOdds + $sumEvens).ToString()[-1] -eq "0"
}
