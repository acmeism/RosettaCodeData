function Get-CheckDigitCUSIP {
    [CmdletBinding()]
    [OutputType([int])]
    Param ( #  Validate input
        [Parameter(Mandatory=$true, Position=0)]
        [ValidatePattern( '^[A-Z0-9@#*]{8}\d$' )] # @#*
        [ValidateScript({$_.Length -eq 9})]
        [string]
        $cusip
    )
    $sum = 0
    0..7 | ForEach { $c = $cusip[$_] ; $v = $null
        if ([Char]::IsDigit($c)) { $v = [char]::GetNumericValue($c) }
        if ([Char]::IsLetter($c)) { $v = [int][char]$c - [int][char]'A' +10 }
        if ($c -eq '*') { $v = 36 }
        if ($c -eq '@') { $v = 37 }
        if ($c -eq '#') { $v = 38 }
        if($_ % 2){ $v += $v }
        $sum += [int][Math]::Floor($v / 10 ) + ($v % 10)
    }
    [int]$checkDigit_calculated = ( 10 - ($sum % 10) ) % 10
    return( $checkDigit_calculated )
}

function Test-IsCUSIP {
    [CmdletBinding()]
    [OutputType([bool])]
    Param (
        [Parameter(Mandatory=$true, Position=0)]
        [ValidatePattern( '^[A-Z0-9@#*]{8}\d$' )]
        [ValidateScript({$_.Length -eq 9})]
        [string]
        $cusip
    )
    [int]$checkDigit_told = $cusip[-1].ToString()
    $checkDigit_calculated = Get-CheckDigitCUSIP $cusip
    ($checkDigit_calculated -eq $checkDigit_told)
}

$data = @"
037833100`tApple Incorporated
17275R102`tCisco Systems
38259P508`tGoogle Incorporated
594918104`tMicrosoft Corporation
68389X106`tOracle Corporation   (incorrect)
68389X105`tOracle Corporation
"@ -split "`n"
$data |%{ Test-IsCUSIP $_.Split("`t")[0] }
