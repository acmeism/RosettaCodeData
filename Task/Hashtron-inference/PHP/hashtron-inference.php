// define hashtron hash
$hash = function($n, $s, $max) {
    // Ensure the inputs are treated as unsigned 32-bit integers
    $n = $n & 0xFFFFFFFF;
    $s = $s & 0xFFFFFFFF;
    $max = $max & 0xFFFFFFFF;

    // Mixing stage, mix input with salt using subtraction
    $m = ($n - $s) & 0xFFFFFFFF;

    // Hashing stage, use xor shift with prime coefficients
    $m ^= ($m << 2) & 0xFFFFFFFF;
    $m ^= ($m << 3) & 0xFFFFFFFF;
    $m ^= ($m >> 5) & 0xFFFFFFFF;
    $m ^= ($m >> 7) & 0xFFFFFFFF;
    $m ^= ($m << 11) & 0xFFFFFFFF;
    $m ^= ($m << 13) & 0xFFFFFFFF;
    $m ^= ($m >> 17) & 0xFFFFFFFF;
    $m ^= ($m << 19) & 0xFFFFFFFF;

    // Mixing stage 2, mix input with salt using addition
    $m = ($m + $s) & 0xFFFFFFFF;

    // Modular stage using multiply-shift trick
    // Cast to 64-bit integer for multiplication
    $result = ((($m & 0xFFFFFFFF) * ($max & 0xFFFFFFFF)) >> 32) & 0xFFFFFFFF;

    return $result;
};


// define hashtron inference
$infer = function($command, $bits, $program) {
    global $hash;
    $out = 0;

    $programLength = count($program);
    if ($programLength == 0) {
        return $out;
    }

    for ($j = 0; $j < $bits; $j++) {
        $input = ($command & 0xFFFFFFFF) | (($j & 0xFF) << 16);

        $ss = $program[0][0];
        $maxx = $program[0][1];

        $input = $hash($input, $ss, $maxx);

        for ($i = 1; $i < $programLength; $i++) {
            $s = $program[$i][0];
            $max = $program[$i][1];
            $maxx -= $max;

            $input = $hash($input, $s, $maxx);
        }

        $input &= 1;
        if ($input != 0) {
            $out |= 1 << $j;
        }
    }

    return $out;
};
