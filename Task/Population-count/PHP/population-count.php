function convertToBinary($integer) {
    $binary = "";

    do {
        $quotient = (int) ($integer / 2);
        $binary .= $integer % 2;
        $integer = $quotient;
    } while ($quotient > 0);

    return $binary;
}

function getPopCount($integer) {
    $binary = convertToBinary($integer);
    $offset = 0;
    $popCount = 0;

    do {
        $pos = strpos($binary, "1", $offset);
        if($pos !== FALSE) $popCount++;
        $offset = $pos + 1;
    } while ($pos !== FALSE);

    return $popCount;
}

function print3PowPopCounts() {
    for ($p = 0; $p < 30; $p++) {
        echo " " . getPopCount(3 ** $p);
    }
}

function printFirst30Evil() {
    $counter = 0;
    $pops = 0;

    while ($pops < 30) {
        $popCount = getPopCount($counter);
        if ($popCount % 2 == 0)  {
            echo " " . $counter;
            $pops++;
        }
        $counter++;
    }
}

function printFirst30Odious() {
    $counter = 1;
    $pops = 0;

    while ($pops < 30) {
        $popCount = getPopCount($counter);
        if ($popCount % 2 != 0)  {
            echo " " . $counter;
            $pops++;
        }
        $counter++;
    }
}

echo "3 ^ x pop counts:";
print3PowPopCounts();

echo "\nfirst 30 evil numbers:";
printFirst30Evil();

echo "\nfirst 30 odious numbers:";
printFirst30Odious();
