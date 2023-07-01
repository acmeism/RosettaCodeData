<?php

function eulers_sum_of_powers () {
	$max_n = 250;
	$pow_5 = array();
	$pow_5_to_n = array();
	for ($p = 1; $p <= $max_n; $p ++) {
		$pow5 = pow($p, 5);
		$pow_5 [$p] = $pow5;
		$pow_5_to_n[$pow5] = $p;
	}
	foreach ($pow_5 as $n_0 => $p_0) {
		foreach ($pow_5 as $n_1 => $p_1) {
			if ($n_0 < $n_1) continue;
			foreach ($pow_5 as $n_2 => $p_2) {
				if ($n_1 < $n_2) continue;
				foreach ($pow_5 as $n_3 => $p_3) {
					if ($n_2 < $n_3) continue;
					$pow_5_sum = $p_0 + $p_1 + $p_2 + $p_3;
					if (isset($pow_5_to_n[$pow_5_sum])) {
						return array($n_0, $n_1, $n_2, $n_3, $pow_5_to_n[$pow_5_sum]);
					}
				}
			}
		}
	}
}

list($n_0, $n_1, $n_2, $n_3, $y) = eulers_sum_of_powers();

echo "$n_0^5 + $n_1^5 + $n_2^5 + $n_3^5 = $y^5";

?>
