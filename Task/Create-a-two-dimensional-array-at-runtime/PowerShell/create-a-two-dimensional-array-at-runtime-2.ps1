[int]$k = 1

for ($i = 0; $i -lt 6; $i++)
{
    0..5 | ForEach-Object -Begin {$k += 10} -Process {$array2d[$i,$_] = $k + $_}
}
