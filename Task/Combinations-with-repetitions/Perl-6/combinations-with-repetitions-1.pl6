my @S = <iced jam plain>;
my $k = 2;

.put for [X](@S xx $k).unique(as => *.sort, with => &[eqv])
