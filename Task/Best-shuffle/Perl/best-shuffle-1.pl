use strict;
use warnings;
use List::Util qw(shuffle);
use Algorithm::Permute;

best_shuffle($_) for qw(abracadabra seesaw elk grrrrrr up a);

sub best_shuffle {
	my ($original_word) = @_;
	my $best_word = $original_word;
	my $best_score = length $best_word;

	my @shuffled = shuffle split //, $original_word;
	my $iterator = Algorithm::Permute->new(\@shuffled);
	
	while( my @array = $iterator->next ) {
		my $word = join '', @array;
		# For each letter which is the same in the two words,
		# there will be a \x00 in the "^" of the two words.
		# The tr operator is then used to count the "\x00"s.
		my $score = ($original_word ^ $word) =~ tr/\x00//;
		next if $score >= $best_score;
		($best_word, $best_score) = ($word, $score);
		last if $score == 0;
	}
	
	print "$original_word, $best_word, $best_score\n";
}
