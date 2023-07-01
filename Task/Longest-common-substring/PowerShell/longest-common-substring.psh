function lcs([String]$a, [String]$b)
{
    if ([String]::IsNullOrEmpty($a) -or [String]::IsNullOrEmpty($b))
    {
        return ""
    }
    $startIndex, $size = -1, -1
    for ($k = 0; $k -lt $a.Length; ++$k)
    {
        for ($i, $j, $d = $k, 0, 0; ($i -lt $a.Length) -and ($j -lt $b.Length); ++$i, ++$j)
        {
            if ($a.Chars($i) -eq $b.Chars($j))
            {
                $d += 1
                if ($size -lt $d)
                {
                    $startIndex = $i - $d + 1
                    $size = $d
                }
            }
            else
            {
                $d = 0
            }
        }
    }
    for ($k = 1; $k -lt $b.Length; ++$k)
    {
        for ($i, $j, $d = 0, $k, 0; ($i -lt $a.Length) -and ($j -lt $b.Length); ++$i, ++$j)
        {
            if ($a.Chars($i) -eq $b.Chars($j))
            {
                $d += 1
                if ($size -lt $d)
                {
                    $startIndex = $i - $d + 1
                    $size = $d
                }
            }
            else
            {
                $d = 0
            }
        }
    }
    if ($size -lt 0)
    {
        return ""
    }
    return $a.Substring($startIndex, $size)
}

function Print-Lcs([String]$a, [String]$b)
{
    return "lcs $a $b = $(lcs $a $b)"
}
Print-Lcs 'thisisatest' 'testing123testing'
Print-Lcs 'testing' 'sting'
Print-Lcs 'thisisatest_stinger' 'testing123testingthing'
Print-Lcs 'thisisatest_stinger' 'thisis'
Print-Lcs 'testing123testingthing' 'thisis'
Print-Lcs 'thisisatest' 'thisisatest'
