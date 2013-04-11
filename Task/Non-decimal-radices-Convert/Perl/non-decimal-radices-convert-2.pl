sub digitize
# Converts an integer to a single digit.
 {my $i = shift;
  $i < 10
    ? $i
    : ('a' .. 'z')[$i - 10];}

sub to_base
 {my ($int, $radix) = @_;
  my $numeral = '';
  do {
    $numeral .= digitize($int % $radix);
  } while $int = int($int / $radix);
  scalar reverse $numeral;}
