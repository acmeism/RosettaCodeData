my $s = 'hello';
say $s ~ ' literal';
my $s1 = $s ~ ' literal';
say $s1;

# or, using mutating concatenation:

$s ~= ' literal';
say $s;
