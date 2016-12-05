for 2..2**19 -> $candidate {
    my $sum = 1 / $candidate;
    for 2 .. ceiling(sqrt($candidate)) -> $factor {
        if $candidate %% $factor {
            $sum += 1 / $factor + 1 / ($candidate / $factor);
        }
    }
    if $sum.nude[1] == 1 {
        say "Sum of reciprocal factors of $candidate = $sum exactly", ($sum == 1 ?? ", perfect!" !! ".");
    }
}
