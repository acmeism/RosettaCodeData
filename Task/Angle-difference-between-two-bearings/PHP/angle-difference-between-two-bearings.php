<?php
  // Angle difference between two bearings

    function get_diff($b1, $b2) {
    $r = ($b2 - $b1) - intdiv($b2 - $b1, 360) * 360;
    if ($r > 180.0)
      $r -= 360.0;
    if ($r < -180.0)
      $r += 360.0;
    return $r;
  }

  function echo_row($b1, $b2) {
    echo str_pad(number_format($b1, 6, ".", ""), 14, " ", STR_PAD_LEFT).'    ';
    echo str_pad(number_format($b2, 6, ".", ""), 14, " ", STR_PAD_LEFT).'    ';
    echo str_pad(number_format(get_diff($b1, $b2), 6), 14, " ", STR_PAD_LEFT);
    echo "\n";
  }

  echo "Input in -180 to +180 range\n";
  echo "     Bearing 1         Bearing 2        Difference\n";
  echo_row(20.0, 45.0);
  echo_row(-45.0, 45.0);
  echo_row(-85.0, 90.0);
  echo_row(-95.0, 90.0);
  echo_row(-45.0, 125.0);
  echo_row(-45.0, 145.0);
  echo_row(-45.0, 125.0);
  echo_row(-45.0, 145.0);
  echo_row(29.4803, -88.6381);
  echo_row(-78.3251, -159.036);
  echo "\nInput in wider range\n";
  echo "     Bearing 1         Bearing 2        Difference\n";
  echo_row(-70099.74233810938, 29840.67437876723);
  echo_row(-165313.6666297357, 33693.9894517456);
  echo_row(1174.8380510598456, -154146.66490124757);
  echo_row(60175.77306795546, 42213.07192354373);
?>
