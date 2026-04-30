$f1 = fn($x) => $x * 2;
$f2 = fn($x) => $x * $x;

$fsf1 = array_map($f1, ?);
$fsf2 = array_map($f2, ?);

var_dump($fsf1([0, 1, 2, 3])); // [0, 2, 4, 6]
var_dump($fsf2([0, 1, 2, 3])); // [0, 1, 4, 9]

var_dump($fsf1([2, 4, 6, 8])); // [4, 8, 12, 16]
var_dump($fsf2([2, 4, 6, 8])); // [4, 16, 36, 64]
