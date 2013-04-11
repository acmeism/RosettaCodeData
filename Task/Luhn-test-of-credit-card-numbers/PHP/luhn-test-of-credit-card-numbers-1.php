$numbers = "49927398716 49927398717 1234567812345678 1234567812345670";
foreach (split(' ', $numbers) as $n)
    echo "$n is ", luhnTest($n) ? 'valid' : 'not valid', '</br>';

function luhnTest($num) {
    $len = strlen($num);
    for ($i = $len-1; $i >= 0; $i--) {
        $ord = ord($num[$i]);
        if (($len - 1) & $i) {
            $sum += $ord;
        } else {
            $sum += $ord / 5 + (2 * $ord) % 10;
        }
    }
    return $sum % 10 == 0;
}
