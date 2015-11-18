function asRational($val, $tolerance = 1.e-6)
{
    if ($val == (int) $val) {
        // integer
        return $val;
    }

    $h1=1;
    $h2=0;
    $k1=0;
    $k2=1;
    $b = 1 / $val;

    do {
        $b = 1 / $b;
        $a = floor($b);
        $aux = $h1;
        $h1 = $a * $h1 + $h2;
        $h2 = $aux;
        $aux = $k1;
        $k1 = $a * $k1 + $k2;
        $k2 = $aux;
        $b = $b - $a;
    } while (abs($val-$h1/$k1) > $val * $tolerance);

    return $h1.'/'.$k1;
}

echo asRational(1/5)."\n"; // "1/5"
echo asRational(1/4)."\n"; // "1/4"
echo asRational(1/3)."\n"; // "1/3"
echo asRational(5)."\n"; // "5"
