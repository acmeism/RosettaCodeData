sub nth_term (Int $n) { $n + round sqrt $n }

say nth_term $_ for 1 .. 22;

loop (my $i = 1; $i <= 1_000_000; $i++) {
    $i.&nth_term.sqrt %% 1 and say "nth_term($i) is square.";
}
