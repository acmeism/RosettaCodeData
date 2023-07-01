use ntheory qw/fromdigits todigitstring/;

print "0  0  0\n";  # Hard code the 0 result
for (0..2e5) {
  # Generate middle-1-palindrome in base 3.
  my $pal = todigitstring($_, 3);
  my $b3 = $pal . "1" . reverse($pal);
  # Convert base 3 number to base 2
  my $b2 = todigitstring(fromdigits($b3, 3), 2);
  # Print results (including base 10) if base-2 palindrome
  print fromdigits($b2,2),"  $b3  $b2\n"   if $b2 eq reverse($b2);
}
