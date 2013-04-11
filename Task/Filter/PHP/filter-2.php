function is_even($var) { return(!($var & 1)); }
$arr = range(1,5);
$evens = array_filter($arr, "is_even");
print_r($evens);
