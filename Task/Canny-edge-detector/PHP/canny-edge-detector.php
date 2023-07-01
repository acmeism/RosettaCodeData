// input: r,g,b in range 0..255
function RGBtoHSV($r, $g, $b) {
	$r = $r/255.; // convert to range 0..1
	$g = $g/255.;
	$b = $b/255.;
	$cols = array("r" => $r, "g" => $g, "b" => $b);
	asort($cols, SORT_NUMERIC);
	$min = key(array_slice($cols, 1)); // "r", "g" or "b"
	$max = key(array_slice($cols, -1)); // "r", "g" or "b"

	// hue
	if($cols[$min] == $cols[$max]) {
		$h = 0;
	} else {
		if($max == "r") {
			$h = 60. * ( 0 + ( ($cols["g"]-$cols["b"]) / ($cols[$max]-$cols[$min]) ) );
		} elseif ($max == "g") {
			$h = 60. * ( 2 + ( ($cols["b"]-$cols["r"]) / ($cols[$max]-$cols[$min]) ) );
		} elseif ($max == "b") {
			$h = 60. * ( 4 + ( ($cols["r"]-$cols["g"]) / ($cols[$max]-$cols[$min]) ) );
		}
		if($h < 0) {
			$h += 360;
		}
	}

	// saturation
	if($cols[$max] == 0) {
		$s = 0;
	} else {
		$s = ( ($cols[$max]-$cols[$min])/$cols[$max] );
		$s = $s * 255;
	}

	// lightness
	$v = $cols[$max];
	$v = $v * 255;

	return(array($h, $s, $v));
}

$filename = "image.png";
$dimensions = getimagesize($filename);
$w = $dimensions[0]; // width
$h = $dimensions[1]; // height

$im = imagecreatefrompng($filename);

for($hi=0; $hi < $h; $hi++) {

	for($wi=0; $wi < $w; $wi++) {
		$rgb = imagecolorat($im, $wi, $hi);

		$r = ($rgb >> 16) & 0xFF;
		$g = ($rgb >> 8) & 0xFF;
		$b = $rgb & 0xFF;
		$hsv = RGBtoHSV($r, $g, $b);

		// compare pixel below with current pixel
		$brgb = imagecolorat($im, $wi, $hi+1);
		$br = ($brgb >> 16) & 0xFF;
		$bg = ($brgb >> 8) & 0xFF;
		$bb = $brgb & 0xFF;
		$bhsv = RGBtoHSV($br, $bg, $bb);

		// if difference in hue > 20, edge is detected
		if($hsv[2]-$bhsv[2] > 20) {
                    imagesetpixel($im, $wi, $hi, imagecolorallocate($im, 255, 0, 0));
		}
                else {
		    imagesetpixel($im, $wi, $hi, imagecolorallocate($im, 0, 0, 0));
		}
			
        }

}

header('Content-Type: image/jpeg');
imagepng($im);
imagedestroy($im);
