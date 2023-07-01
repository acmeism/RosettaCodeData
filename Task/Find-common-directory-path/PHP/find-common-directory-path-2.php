<?php

/* A more compact string-only version, which I assume would be much faster */
/* If you want the trailing /, return $common; */

function getCommonPath($paths) {
	$lastOffset = 1;
	$common = '/';
	while (($index = strpos($paths[0], '/', $lastOffset)) !== FALSE) {
		$dirLen = $index - $lastOffset + 1;	// include /
		$dir = substr($paths[0], $lastOffset, $dirLen);
		foreach ($paths as $path) {
			if (substr($path, $lastOffset, $dirLen) != $dir)
				return $common;
		}
		$common .= $dir;
		$lastOffset = $index + 1;
	}
	return substr($common, 0, -1);
}

?>
