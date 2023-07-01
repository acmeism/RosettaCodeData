use List::Util qw(none);

sub grep_unique {
    my($by, @list) = @_;
    my @seen;
    for (@list) {
        my $x = &$by(@$_);
        $seen[$x]= defined $seen[$x] ? 0 : join ' ', @$_;
    }
    grep { $_ } @seen;
}

sub sums {
    my($n) = @_;
    my @sums;
    push @sums, [$_, $n - $_] for 2 .. int $n/2;
    @sums;
}

sub sum     { $_[0] + $_[1] }
sub product { $_[0] * $_[1] }

for $i (2..97) {
    push @all_pairs, map { [$i, $_] } $i + 1..98
}

# Fact 1:
%p_unique = map { $_ => 1 } grep_unique(\&product, @all_pairs);
for my $p (@all_pairs) {
    push @s_pairs, [@$p] if none { $p_unique{join ' ', @$_} } sums sum @$p;
}

# Fact 2:
@p_pairs = map { [split ' ', $_] } grep_unique(\&product, @s_pairs);

# Fact 3:
@final_pair = grep_unique(\&sum, @p_pairs);

printf "X = %d, Y = %d\n", split ' ', $final_pair[0];
