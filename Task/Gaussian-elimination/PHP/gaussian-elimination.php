function swap_rows(&$a, &$b, $r1, $r2)
{
    if ($r1 == $r2) return;

    $tmp = $a[$r1];
    $a[$r1] = $a[$r2];
    $a[$r2] = $tmp;

    $tmp = $b[$r1];
    $b[$r1] = $b[$r2];
    $b[$r2] = $tmp;
}

function gauss_eliminate($A, $b, $N)
{
    for ($col = 0; $col < $N; $col++)
    {
        $j = $col;
        $max = $A[$j][$j];

        for ($i = $col + 1; $i < $N; $i++)
        {
            $tmp = abs($A[$i][$col]);
            if ($tmp > $max)
            {
                $j = $i;
                $max = $tmp;
            }
        }

        swap_rows($A, $b, $col, $j);

        for ($i = $col + 1; $i < $N; $i++)
        {
            $tmp = $A[$i][$col] / $A[$col][$col];
            for ($j = $col + 1; $j < $N; $j++)
            {
                $A[$i][$j] -= $tmp * $A[$col][$j];
            }
            $A[$i][$col] = 0;
            $b[$i] -= $tmp * $b[$col];
        }
    }
    $x = array();
    for ($col = $N - 1; $col >= 0; $col--)
    {
        $tmp = $b[$col];
        for ($j = $N - 1; $j > $col; $j--)
        {
            $tmp -= $x[$j] * $A[$col][$j];
        }
        $x[$col] = $tmp / $A[$col][$col];
    }
    return $x;
}

function test_gauss()
{
    $a = array(
        array(1.00, 0.00, 0.00,  0.00,  0.00, 0.00),
        array(1.00, 0.63, 0.39,  0.25,  0.16, 0.10),
        array(1.00, 1.26, 1.58,  1.98,  2.49, 3.13),
        array(1.00, 1.88, 3.55,  6.70, 12.62, 23.80),
        array(1.00, 2.51, 6.32, 15.88, 39.90, 100.28),
        array(1.00, 3.14, 9.87, 31.01, 97.41, 306.02)
    );
    $b = array( -0.01, 0.61, 0.91, 0.99, 0.60, 0.02 );

    $x = gauss_eliminate($a, $b, 6);

    ksort($x);
    print_r($x);
}

test_gauss();
