my @symbols = ( [1000, 'M'], [900, 'CM'], [500, 'D'], [400, 'CD'], [100, 'C'], [90, 'XC'], [50, 'L'], [40, 'XL'], [10, 'X'], [9, 'IX'], [5, 'V'], [4, 'IV'], [1, 'I']  );

sub roman {
  my($n, $r) = (shift, '');
  ($r, $n) = ('-', -$n) if $n < 0;  # Optional handling of negative input
  foreach my $s (@symbols) {
    my($arabic, $roman) = @$s;
    ($r, $n) = ($r .= $roman x int($n/$arabic),  $n % $arabic)
       if $n >= $arabic;
  }
  $r;
}

say roman($_) for 1..2012;
