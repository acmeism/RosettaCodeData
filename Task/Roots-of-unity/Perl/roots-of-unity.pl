use Math::Complex;

foreach $n (2 .. 10) {
  printf "%2d", $n;
  foreach $k (0 .. $n-1) {
    $ret = cplxe(1, 2 * pi * $k / $n);
    $ret->display_format(style => 'cartesian', format => '%.3f');
    print " $ret";
  }
  print "\n";
}
