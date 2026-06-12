<?php
// Output the contents of a file (or part of a file) in either hexadecimal or binary

function dump($filename, $mode, $offset=0, $length=null) {
	$data = file_get_contents($filename, false, null, $offset, $length);
	$c = '';
	$h = '';
	$a = $offset;
	$output = '<pre>';

	if ($mode == 'h') {
		$linesize = 16;
		for ($i = 0; $i < strlen($data); $i++) {
			$x = substr($data, $i, 1);
			$h .= bin2hex($x) . ' ';
			if ($i % 8 == 7) {
				$h .= ' ';
			}
			if (ord($x) >= 32 && ord($x) <= 126) {
				$c .= $x;
			}
			else {
				$c .= '.';
			}
			if ($i % $linesize == 15 || $i == strlen($data) - 1) {
				$o = str_pad(dechex($a), 8, '0', STR_PAD_LEFT) . '  ';
				$a += $linesize;
				$h = $o . str_pad($h, 50, ' ', STR_PAD_RIGHT) . '|' . $c . '|';
				$output .= $h . '<br>';
				$c = '';
				$h = '';
			}
		}
	}
	elseif ($mode == 'b') {
		$linesize = 6;
		for ($i = 0; $i < strlen($data); $i++) {
			$x = substr($data, $i, 1);
			$h .= str_pad(decbin(ord($x)), 8, '0', STR_PAD_LEFT) . ' ';
			if (ord($x) >= 32 && ord($x) <= 126) {
				$c .= $x;
			}
			else {
				$c .= '.';
			}
			if ($i % $linesize == 5 || $i == strlen($data) - 1) {
				$o = str_pad(dechex($a), 8, '0', STR_PAD_LEFT) . '  ';
				$a += $linesize;
				$h = $o . str_pad($h, 54, ' ', STR_PAD_RIGHT) . '|' . $c . '|';
				$output .= $h . '<br>';
				$c = '';
				$h = '';
			}
		}
	}
// final byte count
	$output .=str_pad(dechex(strlen($data)), 8, '0', STR_PAD_LEFT) . '  ';
	$output .= '</pre>';
	return $output;
}
$x = dump("file1.txt", "h");
echo '<p>Hexadecimal dump of file' . $x . '</p>';

$x = dump("file1.txt", "h", 10, 20);
echo '<p>Hexadecimal dump of 20 bytes of file from offset 10' . $x . '</p>';

$x = dump("file1.txt", "b");
echo '<p>Binary dump of file1' . $x . '</p>';
?>
