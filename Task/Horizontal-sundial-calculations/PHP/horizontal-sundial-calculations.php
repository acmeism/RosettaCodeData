<?php
// Horizontal sundial calculations

function dec_format($nr, $len, $fr) {
  if ($fr == 0)
    return str_pad(number_format($nr, 0), $len, " ",STR_PAD_LEFT);
  else
    return str_pad(number_format($nr, $fr, ".", ""), $len, " ", STR_PAD_LEFT);
}

$lat = (float)readline('Enter latitude       => ');
$lng = (float)readline('Enter longitude      => ');
$ref = (float)readline('Enter legal meridian => ');
echo PHP_EOL;
$s_lat = sin(deg2rad($lat));
echo '    sine of latitude:    '.$s_lat.PHP_EOL;
echo '    diff longitude:      '.($lng - $ref).PHP_EOL;
echo PHP_EOL;
echo 'Hour, sun hour angle, dial hour line angle from 6am to 6pm'.PHP_EOL;
for ($hour = -6; $hour <= 6; $hour++) {
  $hour_angle = 15 * $hour;
  $hour_angle = $hour_angle - ($lng - $ref); // correct for longitude difference
  $hour_line_angle = rad2deg(atan($s_lat * tan(deg2rad($hour_angle))));
  echo 'HR='.dec_format($hour, 3, 0);
  echo '; HRA='.dec_format($hour_angle, 8, 3);
  echo '; HLA='.dec_format($hour_line_angle, 8, 3).PHP_EOL;
}
?>
