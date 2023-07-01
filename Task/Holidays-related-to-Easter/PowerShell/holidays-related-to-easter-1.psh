function Get-Easter
{
    [CmdletBinding()]
    [OutputType([PSCustomObject])]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [int]
        $Year
    )

    Begin
    {
        $holidayOffset = [ordered]@{
            Easter    = 0
            Ascension = 39
            Pentecost = 49
            Trinity   = 56
            Corpus    = 60
        }

        function Get-DateOfEaster ([int]$Year)
        {
            [int]$a = $Year % 19
            [int]$b = [Math]::Truncate($Year / 100)
            [int]$c = $Year % 100
            [int]$d = [Math]::Truncate($b / 4)
            [int]$e = $b % 4
            [int]$f = [Math]::Truncate(($b + 8) / 25)
            [int]$g = [Math]::Truncate(($b - $f + 1) / 3)
            [int]$h = ((19 * $a) + $b - $d - $g + 15) % 30
            [int]$i = [Math]::Truncate($c / 4)
            [int]$j = $c % 4
            [int]$k = (32 + 2 * ($e + $i) - $h - $j) % 7
            [int]$l = [Math]::Truncate(($a + (11 * $h) + (22 * $k)) / 451)
            [int]$m = [Math]::Truncate(($h + $k - (7 * $l) + 114) / 31)
            [int]$d = (($h + $k - (7 * $l) + 114) % 31) + 1

            Get-Date -Year $Year -Month $m -Day $d
        }

        function Get-Holiday ([int]$Year)
        {
            $easter = Get-DateOfEaster -Year $Year

            $holidays = foreach ($key in $holidayOffset.Keys)
            {
                $easter.AddDays($holidayOffset.$key)
            }

            [PSCustomObject]@{
                Year      = $Year
                Easter    = $holidays[0].ToString("ddd dd MMM")
                Ascension = $holidays[1].ToString("ddd dd MMM")
                Pentecost = $holidays[2].ToString("ddd dd MMM")
                Trinity   = $holidays[3].ToString("ddd dd MMM")
                Corpus    = $holidays[4].ToString("ddd dd MMM")
            }
        }
    }
    Process
    {
        foreach ($y in $Year)
        {
            Get-Holiday -Year $y
        }
    }
}
