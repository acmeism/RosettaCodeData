$key2val = ["A"=>"30", "B"=>"31", "C"=>"32", "D"=>"33", "E"=>"5", "F"=>"34", "G"=>"35",
        "H"=>"0", "I"=>"36", "J"=>"37", "K"=>"38", "L"=>"2", "M"=>"4", "."=>"78", "N"=>"39",
        "/"=>"79", "O"=>"1", "0"=>"790", "P"=>"70", "1"=>"791", "Q"=>"71", "2"=>"792",
        "R"=>"8", "3"=>"793", "S"=>"6", "4"=>"794", "T"=>"9", "5"=>"795", "U"=>"72",
        "6"=>"796", "V"=>"73", "7"=>"797", "W"=>"74", "8"=>"798", "X"=>"75", "9"=>"799",
        "Y"=>"76", "Z"=>"77"];

$val2key = array_flip($key2val);

function encode(string $s) : string  {
    global $key2val;

    $callback = function($c) use ($key2val) { return $key2val[$c] ?? ''; };

    return implode(array_map($callback, str_split(strtoupper($s))));
}

function decode(string $s) : string {
     global $val2key;

     $callback = function($c) use ($val2key) { return $val2key[$c] ?? ''; };

     preg_match_all('/79.|7.|3.|./', $s, $m);

     return implode(array_map($callback, $m[0]));
}

function main($s) {
    $encoded = encode($s);
    echo $encoded;
    echo "\n";
    echo decode($encoded);
}

main('One night-it was on the twentieth of March, 1888-I was returning');
