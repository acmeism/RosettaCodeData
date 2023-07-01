use strict;
use warnings;
use English;
use Const::Fast;
use Math::AnyNum qw(:overload);

const my $n_max       => 10_000;
const my $iter_cutoff => 500;
my(@seq_dump, @seed_lychrels, @related_lychrels);

for (my $n=1; $n<=$n_max; $n++) {
    my @seq = lychrel_sequence($n);
    if ($iter_cutoff == scalar @seq) {
        if (has_overlap(\@seq, \@seq_dump)) { push @related_lychrels, $n }
        else                                { push @seed_lychrels,    $n }
        @seq_dump = set_union(\@seq_dump, \@seq);
    }
}

printf "%45s %s\n", "Number of seed Lychrels <= $n_max:",        scalar @seed_lychrels;
printf "%45s %s\n", "Seed Lychrels <= $n_max:",              join ', ', @seed_lychrels;
printf "%45s %s\n", "Number of related Lychrels <= $n_max:",     scalar @related_lychrels;
printf "%45s %s\n", "Palindromes among seed and related <= $n_max:",
                    join ', ', sort {$a <=> $b} grep { is_palindrome($ARG) } @seed_lychrels, @related_lychrels;

sub lychrel_sequence {
    my $n = shift;
    my @seq;
    for (1 .. $iter_cutoff) {
        return if is_palindrome($n = next_n($n));
        push @seq, $n;
    }
    @seq;
}

sub next_n        { my $n = shift; $n  + reverse($n) }
sub is_palindrome { my $n = shift; $n eq reverse($n) }

sub has_overlap {
    my ($a, $b) = @ARG;
    my %h;
    $h{$_}++ for @{$a};
    exists $h{$_} and return 1 for @{$b};
    0;
}

sub set_union {
    my ($a, $b) = @ARG;
    my %h;
    $h{$_}++ for @{$a}, @{$b};
    keys %h;
}
