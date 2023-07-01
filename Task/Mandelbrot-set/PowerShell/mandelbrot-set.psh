$x = $y = $i = $j = $r = -16
$colors = [Enum]::GetValues([System.ConsoleColor])

while(($y++) -lt 15)
{
    for($x=0; ($x++) -lt 84; Write-Host " " -BackgroundColor ($colors[$k -band 15]) -NoNewline)
    {
        $i = $k = $r = 0

        do
        {
            $j = $r * $r - $i * $i -2 + $x / 25
            $i = 2 * $r * $i + $y / 10
            $r = $j
        }
        while (($j * $j + $i * $i) -lt 11 -band ($k++) -lt 111)
    }

    Write-Host
}
