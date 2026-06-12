<?php
// Find the smallest positive integer k such that the decimal expansion of k^k
// contains n, where n < 51
// Requires 'bcmath' extension.

$result = array();

for ($k = 1; count($result) < 51; $k++) {
	$i = bcpow($k, $k);
	for ($n = 0; $n < 51; $n++) {
		if (str_contains($i, $n)) {
			if (empty($result[$n])) {
				$result[$n] = $k;
			}
		}
	}
}

ksort($result);
for ($i = 0; $i < count($result); $i++) {
	echo $result[$i] . ' ';
}

?>
