$character = [PSCustomObject]@{
    aleph  = [PSCustomObject]@{Expected=1/5       ; Alpha="א"}
    beth   = [PSCustomObject]@{Expected=1/6       ; Alpha="ב"}
    gimel  = [PSCustomObject]@{Expected=1/7       ; Alpha="ג"}
    daleth = [PSCustomObject]@{Expected=1/8       ; Alpha="ד"}
    he     = [PSCustomObject]@{Expected=1/9       ; Alpha="ה"}
    waw    = [PSCustomObject]@{Expected=1/10      ; Alpha="ו"}
    zayin  = [PSCustomObject]@{Expected=1/11      ; Alpha="ז"}
    heth   = [PSCustomObject]@{Expected=1759/27720; Alpha="ח"}
}

$sum        = 0
$iterations = 1000000
$cumulative = [ordered]@{}
$randomly   = [ordered]@{}

foreach ($name in $character.PSObject.Properties.Name)
{
    $sum += $character.$name.Expected
    $cumulative.$name = $sum
    $randomly.$name = 0
}

for ($i = 0; $i -lt $iterations; $i++)
{
    $random = Get-Random -Minimum 0.0 -Maximum 1.0

    foreach ($name in $cumulative.Keys)
    {
        if ($random -le $cumulative.$name)
        {
            $randomly.$name++
            break
        }
    }
}

foreach ($name in $character.PSObject.Properties.Name)
{
    [PSCustomObject]@{
        Name      = $name
        Expected  = $character.$name.Expected
        Actual    = $randomly.$name / $iterations
        Character = $character.$name.Alpha
    }
}
