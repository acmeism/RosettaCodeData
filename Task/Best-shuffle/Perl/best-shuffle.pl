use strict;
use Algorithm::Permute;

foreach ("abracadabra", "seesaw", "elk", "grrrrrr", "up", "a") {
    best_shuffle($_);
}

sub score {
    my ($original_word,$new_word) = @_;
    my $result = 0;
    for (my $i = 0 ; $i < length($original_word) ; $i++) {
        if (substr($original_word,$i,1) eq substr($new_word,$i,1)) {
            $result++;
        }
    }
    return $result;
}

sub best_shuffle {
    my ($original_word) = @_;
    my $best_word = $original_word;
    my $best_score = length($original_word);
    my @array = split(//,$original_word);

    # The below was adapted from perlfaq4

    my $p_iterator = Algorithm::Permute->new( \@array );

    while (my @array = $p_iterator->next) {
        if (score($original_word,join("",@array))<$best_score) {
            $best_score = score($original_word, join("",@array));
            $best_word = join ("",@array);
        }
        last if ($best_score == 0);
    }

    print "$original_word, $best_word, $best_score\n";
}
