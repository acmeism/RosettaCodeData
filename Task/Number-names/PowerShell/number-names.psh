function Get-NumberName
{
  <#
    .SYNOPSIS
        Spells out a number in English.
    .DESCRIPTION
        Spells out a number in English in the range of 0 to 999,999,999.
    .NOTES
        The code for this function was copied (almost word for word) from the C#
        example on this page to show how similar Powershell is to C#.
    .PARAMETER Number
        One or more integers in the range of 0 to 999,999,999.
    .EXAMPLE
        Get-NumberName -Number 666
    .EXAMPLE
        Get-NumberName 1, 234, 31337, 987654321
    .EXAMPLE
        1, 234, 31337, 987654321 | Get-NumberName
  #>
    [CmdletBinding()]
    [OutputType([string])]
    Param
    (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateRange(0,999999999)]
        [int[]]
        $Number
    )

    Begin
    {
        [string[]]$incrementsOfOne = "zero",    "one",     "two",       "three",    "four",
                                     "five",    "six",     "seven",     "eight",    "nine",
                                     "ten",     "eleven",  "twelve",    "thirteen", "fourteen",
                                     "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"

        [string[]]$incrementsOfTen = "",      "",      "twenty",  "thirty", "fourty",
                                     "fifty", "sixty", "seventy", "eighty", "ninety"

        [string]$millionName  = "million"
        [string]$thousandName = "thousand"
        [string]$hundredName  = "hundred"
        [string]$andName      = "and"

        function GetName([int]$i)
        {
            [string]$output = ""

            if ($i -ge 1000000)
            {
                $remainder = $null
                $output += (ParseTriplet ([Math]::DivRem($i,1000000,[ref]$remainder))) + " " + $millionName
                $i = $remainder

                if ($i -eq 0) { return $output }
            }

            if ($i -ge 1000)
            {
                if ($output.Length -gt 0)
                {
                    $output += ", "
                }

                $remainder = $null
                $output += (ParseTriplet ([Math]::DivRem($i,1000,[ref]$remainder))) + " " + $thousandName
                $i = $remainder

                if ($i -eq 0) { return $output }
            }

            if ($output.Length -gt 0)
            {
                $output += ", "
            }

            $output += (ParseTriplet $i)

            return $output
        }

        function ParseTriplet([int]$i)
        {
            [string]$output = ""

            if ($i -ge 100)
            {
                $remainder = $null
                $output += $incrementsOfOne[([Math]::DivRem($i,100,[ref]$remainder))] + " " + $hundredName
                $i = $remainder

                if ($i -eq 0) { return $output }
            }

            if ($output.Length -gt 0)
            {
                $output += " " + $andName + " "
            }

            if ($i -ge 20)
            {
                $remainder = $null
                $output += $incrementsOfTen[([Math]::DivRem($i,10,[ref]$remainder))]
                $i = $remainder

                if ($i -eq 0) { return $output }
            }

            if ($output.Length -gt 0)
            {
                $output += " "
            }

            $output += $incrementsOfOne[$i]

            return $output
        }
    }
    Process
    {
        foreach ($n in $Number)
        {
            [PSCustomObject]@{
                Number = $n
                Name   = GetName $n
            }
        }
    }
}

1, 234, 31337, 987654321 | Get-NumberName
