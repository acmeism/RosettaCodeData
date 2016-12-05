sub nth-term (Int $n) { $n + round sqrt $n }

# Print the first 22 values of the sequence
say (nth-term $_ for 1 .. 22);

# Check that the first million values of the sequence are indeed non-square
for 1 .. 1_000_000 -> $i {
    say "Oops, nth-term($i) is square!" if (sqrt nth-term $i) %% 1;
}
