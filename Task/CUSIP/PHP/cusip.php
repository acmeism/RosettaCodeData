function IsCusip(string $s) {
    if (strlen($s) != 9) return false;
    $sum = 0;
    for ($i = 0; $i <= 7; $i++) {
        $c = $s[$i];
        if (ctype_digit($c)) {
            // if character is numeric, get character's numeric value
            $v = intval($c);
        } elseif (ctype_alpha($c)) {
            // if character is alphabetic, get character's ordinal position in alphabet
            $position = ord(strtoupper($c)) - ord('A') + 1;
            $v = $position + 9;
        } elseif ($c == "*") {
            $v = 36;
        } elseif ($c == "@") {
            $v = 37;
        } elseif ($c == "#") {
            $v = 38;
        } else {
            return false;
        }
        // is this character position even?
        if ($i % 2 == 1) {
            $v *= 2;
        }
        // calculate the checksum digit
        $sum += floor($v / 10 ) + ( $v % 10 );
    }
    return ord($s[8]) - 48 == (10 - ($sum % 10)) % 10;
}

$cusips = array("037833100",
                "17275R102",
                "38259P508",
                "594918104",
                "68389X106",
                "68389X105");

foreach ($cusips as $cusip) echo $cusip . " -> " . (IsCusip($cusip) ? "valid" : "invalid") . "\n";
