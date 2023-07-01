sub super (\d) {
    my \run = d x d;
    ^∞ .hyper.grep: -> \n { (d * n ** d).Str.contains: run }
}

(2..9).race(:1batch).map: {
    my $now = now;
    put "\nFirst 10 super-$_ numbers:\n{.&super[^10]}\n{(now - $now).round(.1)} sec."
}
