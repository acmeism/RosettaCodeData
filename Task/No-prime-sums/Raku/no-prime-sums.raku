say "Sequence, starting with 1, then:";

for '', (*), 'odd ', (* % 2), 'even ', (* %% 2) -> $label, $filter {
    my @check = 0, 1;
    my @seq = 1, |lazy gather loop {
        state $last = 1;
        take $last = ($last^..Inf).grep($filter).hyper.grep({ none (@check.grep({.defined}) »+» $_)».is-prime })[0];
        @check.append: @check »+» $last;
    }

    say "\nlexicographically  earliest {$label}integer such that no subsequence sums to a prime:\n",
    @seq[^10];
}
