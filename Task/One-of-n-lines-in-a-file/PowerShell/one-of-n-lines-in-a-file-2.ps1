class Holder {
    [System.Random]$rng

    Holder()
    {
        $this.rng = [System.Random]::new()
    }

    [int] GetOneOfN([int]$Number)
    {
        $current = 1

        for ($i = 2; $i -le $Number; $i++)
        {
            $limit = 1 / $i

            if ($this.rng.NextDouble() -lt $limit)
            {
                $current = $i
            }
        }

        return $current
    }
}


$table = [Collections.Generic.Dictionary[int, int]]::new()
$X = [Holder]::new()

1..10 | ForEach-Object {
    $table.Add($_, 0)
}

for ($i = 0; $i -lt 1e6; $i++)
{
    $index = $X.GetOneOfN(10) - 1
    $table[$index] += 1
}

[PSCustomObject]$table
