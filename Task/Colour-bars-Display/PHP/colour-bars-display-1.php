<?php
$colors = array(array(  0,   0,   0),   // black
                array(255,   0,   0),   // red
                array(  0, 255,   0),   // green
                array(  0,   0, 255),   // blue
                array(255,   0, 255),   // magenta
                array(  0, 255, 255),   // cyan
                array(255, 255,   0),   // yellow
                array(255, 255, 255));  // white

define('BARWIDTH', 640 / count($colors));
define('HEIGHT',   480);

$image = imagecreate(BARWIDTH * count($colors), HEIGHT);

foreach ($colors as $position => $color) {
    $color = imagecolorallocate($image, $color[0], $color[1], $color[2]);
    imagefilledrectangle($image, $position * BARWIDTH, 0,
                         $position * BARWIDTH + BARWIDTH - 1,
                         HEIGHT - 1, $color);
}

header('Content-type:image/png');
imagepng($image);
imagedestroy($image);
