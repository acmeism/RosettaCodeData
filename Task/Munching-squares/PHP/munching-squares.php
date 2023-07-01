header("Content-Type: image/png");

$w = 256;
$h = 256;

$im = imagecreate($w, $h)
    or die("Cannot Initialize new GD image stream");

$color = array();
for($i=0;$i<256;$i++)
{
        array_push($color,imagecolorallocate($im,sin(($i)*(2*3.14/256))*128+128,$i/2,$i));
}

for($i=0;$i<$w;$i++)
{
        for($j=0;$j<$h;$j++)
        {
                imagesetpixel($im,$i,$j,$color[$i^$j]);
        }
}

imagepng($im);
imagedestroy($im);
