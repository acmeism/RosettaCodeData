sub pistream {
  my $digits = shift;
  my(@out, @a);
  my($b, $c, $d, $e, $f, $g, $i, $d4, $d3, $d2, $d1);
  my $outi = 0;

  $digits++;
  $b = $d = $e = $g = $i = 0;
  $f = 10000;
  $c = 14 * (int($digits/4)+2);
  @a = (20000000) x $c;
  print "3.";
  while (($b = $c -= 14) > 0 && $i < $digits) {
    $d = $e = $d % $f;
    while (--$b > 0) {
      $d = $d * $b + $a[$b];
      $g = ($b << 1) - 1;
      $a[$b] = ($d % $g) * $f;
      $d = int($d / $g);
    }
    $d4 = $e + int($d/$f);
    if ($d4 > 9999) {
      $d4 -= 10000;
      $out[$i-1]++;
      for ($b = $i-1; $out[$b] == 1; $b--) {
        $out[$b] = 0;
        $out[$b-1]++;
      }
    }
    $d3 = int($d4/10);
    $d2 = int($d3/10);
    $d1 = int($d2/10);
    $out[$i++] = $d1;
    $out[$i++] = $d2-$d1*10;
    $out[$i++] = $d3-$d2*10;
    $out[$i++] = $d4-$d3*10;
    print join "", @out[$i-15 .. $i-15+3]  if $i >= 16;
  }
  # We've closed the spigot.  Print the remainder without rounding.
  print join "", @out[$i-15+4 .. $digits-2], "\n";
}
