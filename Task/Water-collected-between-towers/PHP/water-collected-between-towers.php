<?php
$tower = "\u{2588}" . "\u{2588}";
$empty = '  ';
$water = '==';

$build = array(
 array(1, 5, 3, 7, 2),
 array(5, 3, 7, 2, 6, 4, 5, 9, 1, 2),
 array(2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1),
 array(5, 5, 5, 5),
 array(5, 6, 7, 8),
 array(8, 7, 7, 6),
 array(6, 7, 10, 7, 6)
);

// Calculate
for ($i = 0; $i < count($build); $i++) {
	$level = array();
	for ($j = 1; $j < count($build[$i]) - 1; $j++) {
		$w = 0;
		$l = $r = 0;
		for ($k = 0; $k < $j; $k++) {
			if ($build[$i][$k] > $build[$i][$j]) {
				$l = max($l, $build[$i][$k]);
			}
		}
		for ($k = $j + 1; $k < count($build[$i]); $k++) {
			if ($build[$i][$k] > $build[$i][$j]) {
				$r = max($r, $build[$i][$k]);
			}
		}
		if ($l > 0 && $r > 0) {
			$w = min($l, $r) - $build[$i][$j];
			$level[$j] = $w;
		}
	}

// Report
	echo '<pre>';
	$max = max($build[$i]);
	$u = 0;
	for ($j = $max; $j > 0; $j--) {
		for ($k = 0; $k < count($build[$i]); $k++) {
			if ($j - 1 < $build[$i][$k]) {
				echo $tower;
			}
			elseif (!empty($level[$k]) && $level[$k] + $build[$i][$k] >= $j) {
				echo $water;
				$u++;
			}
			elseif ($build[$i][$k] < $j) {
				echo $empty;
			}
		}
		echo '<br>';
	}
	echo '<br>Block ' . $i + 1 . ' will collect ' . $u . ' units of water<br>';
	echo '</pre>';
}
?>
