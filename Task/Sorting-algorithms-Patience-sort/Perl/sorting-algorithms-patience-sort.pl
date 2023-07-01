sub patience_sort {
    my @s = [shift];
    for my $card (@_) {
	my @t = grep { $_->[-1] > $card } @s;
	if (@t) { push @{shift(@t)}, $card }
	else { push @s, [$card] }
    }
    my @u;
    while (my @v = grep @$_, @s) {
	my $value = (my $min = shift @v)->[-1];
	for (@v) {
	    ($min, $value) =
	    ($_, $_->[-1]) if $_->[-1] < $value
	}
	push @u, pop @$min;
    }
    return @u
}

print join ' ', patience_sort qw(4 3 6 2 -1 13 12 9);
