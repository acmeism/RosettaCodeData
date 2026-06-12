use v5.036;
use Path::Tiny;
use List::Util <uniq head>;

sub bi_gram {
    my $line = lc shift;
    uniq map { substr $line,$_,2 } 0..length($line)-2;
}

sub score {
    my($phrase, $word) = @_;
    my %count;
    my @match = bi_gram $phrase;
    $count{$_}++ for @match, @$word;
    2 * (grep { $count{$_} > 1 } keys %count) / (@match + @$word);
}

sub sorensen {
    my($dict,$word,$cutoff) = @_; $cutoff //= 0.00;
    my(%matches,$s);
    ($s = score($word, $$dict{$_})) > $cutoff and $matches{$_} = $s for keys %$dict;
    %matches;
}

my %dict = map { $_ => [ bi_gram($_) ] } path('ref/Sorensen-Dice-Tasks.txt')->slurp =~ /.{10,}/gm;

for my $word ( ('Primordial primes', 'Sunkist-Giuliani formula', 'Sieve of Euripides', 'Chowder numbers') ) {
    my(%scored,@ranked);
    %scored = sorensen(\%dict,$word);
    push @ranked, sprintf "%.3f $_", $scored{$_} for sort { $scored{$b} <=> $scored{$a} || $a cmp $b } keys %scored;
    say "\n$word:\n" . join("\n", head 5, @ranked);
}
