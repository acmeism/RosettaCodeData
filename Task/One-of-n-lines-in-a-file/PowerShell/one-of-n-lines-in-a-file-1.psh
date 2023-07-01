function Get-OneOfN ([int]$Number)
{
    $current = 1

    for ($i = 2; $i -le $Number; $i++)
    {
        $limit = 1 / $i

        if ((Get-Random -Minimum 0.0 -Maximum 1.0) -lt $limit)
        {
            $current = $i
        }
    }

    $current
}


$table = [ordered]@{}

for ($i = 1; $i -lt 11; $i++)
{
    $table.Add(("Line {0,2}" -f $i), 0)
}

for ($i = 0; $i -lt 1000000; $i++)
{
    $index = (Get-OneOfN -Number 10) - 1
    $table[$index] = $table[$index] + 1
}

[PSCustomObject]$table
