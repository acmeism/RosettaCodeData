<?php

function gcd($a, $b)
{
    if ($a == 0)
       return $b;
    if ($b == 0)
       return $a;
    if($a == $b)
        return $a;
    if($a > $b)
        return gcd($a-$b, $b);
    return gcd($a, $b-$a);
}

$pytha = 0;
$prim = 0;
$max_p = 100;

for ($a = 1; $a <= $max_p / 3; $a++) {
    $aa = $a**2;
    for ($b = $a + 1; $b < $max_p/2; $b++) {
        $bb = $b**2;
        for ($c = $b + 1; $c < $max_p/2; $c++) {
            $cc = $c**2;
            if ($aa + $bb < $cc) break;
            if ($a + $b + $c > $max_p) break;

            if ($aa + $bb == $cc) {
                $pytha++;
                if (gcd($a, $b) == 1) $prim++;
            }
        }
    }
}

echo 'Up to ' . $max_p . ', there are ' . $pytha . ' triples, of which ' . $prim . ' are primitive.';
