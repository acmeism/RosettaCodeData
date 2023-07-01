function identity($length) {
	return array_map(function($key, $value) {$value[$key] = 1; return $value;}, range(0, $length-1),
	array_fill(0, $length, array_fill(0,$length, 0)));
}
function print_identity($identity) {
	echo implode(PHP_EOL, array_map(function ($value) {return implode(' ', $value);}, $identity));
}
print_identity(identity(10));
