function output([Object[]]$A, [Int]$k, [ref]$sign)
{
    "Perm: [$([String]::Join(', ', $A))] Sign: $($sign.Value)"
}

function permutation([Object[]]$array)
{
    function generate([Object[]]$A, [Int]$k, [ref]$sign)
    {
        if($k -eq 1)
        {
            output $A $k $sign
            $sign.Value = -$sign.Value
        }
        else
        {
            $k -= 1
            generate $A  $k $sign
            for([Int]$i = 0; $i -lt $k; $i += 1)
             {
                if($i % 2 -eq 0)
                {
                    $A[$i], $A[$k] = $A[$k], $A[$i]
                }
                else
                {
                    $A[0], $A[$k] = $A[$k], $A[0]
                }
                generate $A $k $sign
            }
        }
    }
    generate $array $array.Count ([ref]1)
}
permutation @(0, 1, 2)
""
permutation @(0, 1, 2, 3)
