use strict;
use warnings;
use feature 'bitwise';
use List::Util qw(shuffle);

best_shuffle($_) for qw(abracadabra seesaw elk grrrrrr up a);

sub best_shuffle {
	my ($original_word) = @_;

	my @s = split //, $original_word;
	my @t = shuffle @s;

	for my $i ( 0 .. $#s ) {
		for my $j ( 0 .. $#s ) {
			next if $j == $i or
				$t[$i] eq $s[$j] or
				$t[$j] eq $s[$i];
			@t[$i,$j] = @t[$j,$i];
			last;
		}
	}
	
	my $word = join '', @t;

	my $score = ($original_word ^. $word) =~ tr/\x00//;
	print "$original_word, $word, $score\n";
}
