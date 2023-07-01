function ownCalcPass($password, $nonce) {
    $msr = 0x7FFFFFFF;
    $m_1 = (int)0xFFFFFFFF;
    $m_8 = (int)0xFFFFFFF8;
    $m_16 = (int)0xFFFFFFF0;
    $m_128 = (int)0xFFFFFF80;
    $m_16777216 = (int)0xFF000000;
    $flag = True;
    $num1 = 0;
    $num2 = 0;

    foreach (str_split($nonce) as $c) {
        $num1 = $num1 & $m_1;
        $num2 = $num2 & $m_1;
        if ($c == '1') {
            $length = !$flag;
            if (!$length) {
                $num2 = $password;
            }
            $num1 = $num2 & $m_128;
            $num1 = $num1 >> 1;
            $num1 = $num1 & $msr;
            $num1 = $num1 >> 6;
            $num2 = $num2 << 25;
            $num1 = $num1 + $num2;
            $flag = False;
        } elseif ($c == '2') {
            $length = !$flag;
            if (!$length) {
                $num2 = $password;
            }
            $num1 = $num2 & $m_16;
            $num1 = $num1 >> 1;
            $num1 = $num1 & $msr;
            $num1 = $num1 >> 3;
            $num2 = $num2 << 28;
            $num1 = $num1 + $num2;
            $flag = False;
        } elseif ($c == '3') {
            $length = !$flag;
            if (!$length) {
                $num2 = $password;
            }
            $num1 = $num2 & $m_8;
            $num1 = $num1 >> 1;
            $num1 = $num1 & $msr;
            $num1 = $num1 >> 2;
            $num2 = $num2 << 29;
            $num1 = $num1 + $num2;
            $flag = False;
        } elseif ($c == '4') {
            $length = !$flag;
            if (!$length) {
                $num2 = $password;
            }
            $num1 = $num2 << 1;
            $num2 = $num2 >> 1;
            $num2 = $num2 & $msr;
            $num2 = $num2 >> 30;
            $num1 = $num1 + $num2;
            $flag = False;
        } elseif ($c == '5') {
            $length = !$flag;
            if (!$length) {
                $num2 = $password;
            }
            $num1 = $num2 << 5;
            $num2 = $num2 >> 1;
            $num2 = $num2 & $msr;
            $num2 = $num2 >> 26;
            $num1 = $num1 + $num2;
            $flag = False;
        } elseif ($c == '6') {
            $length = !$flag;
            if (!$length) {
                $num2 = $password;
            }
            $num1 = $num2 << 12;
            $num2 = $num2 >> 1;
            $num2 = $num2 & $msr;
            $num2 = $num2 >> 19;
            $num1 = $num1 + $num2;
            $flag = False;
        } elseif ($c == '7') {
            $length = !$flag;
            if (!$length) {
                $num2 = $password;
            }
            $num1 = $num2 & 0xFF00;
            $num1 = $num1 + (( $num2 & 0xFF ) << 24 );
            $num1 = $num1 + (( $num2 & 0xFF0000 ) >> 16 );
            $num2 = $num2 & $m_16777216;
            $num2 = $num2 >> 1;
            $num2 = $num2 & $msr;
            $num2 = $num2 >> 7;
            $num1 = $num1 + $num2;
            $flag = False;
        } elseif ($c == '8') {
            $length = !$flag;
            if (!$length) {
                $num2 = $password;
            }
            $num1 = $num2 & 0xFFFF;
            $num1 = $num1 << 16;
            $numx = $num2 >> 1;
            $numx = $numx & $msr;
            $numx = $numx >> 23;
            $num1 = $num1 + $numx;
            $num2 = $num2 & 0xFF0000;
            $num2 = $num2 >> 1;
            $num2 = $num2 & $msr;
            $num2 = $num2 >> 7;
            $num1 = $num1 + $num2;
            $flag = False;
        } elseif ($c == '9') {
            $length = !$flag;
            if (!$length) {
                $num2 = $password;
            }
            $num1 = ~(int)$num2;
            $flag = False;
        } else {
            $num1 = $num2;
        }
        $num2 = $num1;
    }
    return sprintf('%u', $num1 & $m_1);
}
