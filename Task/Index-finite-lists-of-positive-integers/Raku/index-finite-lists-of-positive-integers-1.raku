sub rank(*@n)      { :11(@n.join('A')) }
sub unrank(Int $n) { $n.base(11).split('A') }

say my @n = (1..20).roll(12);
say my $n = rank(@n);
say unrank $n;
