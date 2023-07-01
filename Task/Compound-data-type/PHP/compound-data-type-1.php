# Using pack/unpack
$point = pack("ii", 1, 2);

$u = unpack("ix/iy", $point);
echo $x;
echo $y;

list($x,$y) = unpack("ii", $point);
echo $x;
echo $y;
