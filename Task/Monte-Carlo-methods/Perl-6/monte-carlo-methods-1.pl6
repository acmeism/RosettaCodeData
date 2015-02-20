my @random_distances := ([+] rand**2 xx 2) xx *;

sub approximate_pi(Int $n) {
    4 * @random_distances[^$n].grep(* < 1) / $n
}

say "Monte-Carlo π approximation:";
say "$_ iterations:  ", approximate_pi $_
    for 100, 1_000, 10_000;
