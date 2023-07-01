use strict;
use List::Util qw(max);

sub mode
{
    my %c;
    foreach my $e ( @_ ) {
	$c{$e}++;
    }
    my $best = max(values %c);
    return grep { $c{$_} == $best } keys %c;
}
