sub postfix:<!> ($n) { constant @F = (1, 1, |[\*] 2..*); @F[$n] }
sub abr ($_) { .chars < 41 ?? $_ !! .substr(0,20) ~ '..' ~ .substr(*-20) ~ " ({.chars} digits)" }

my $limit;

for 1..* {
    my \f = .!;
    ++$limit and printf "%2d: %3d! - 1 = %s\n", $limit, $_, abr f -1 if (f -1).is-prime;
    ++$limit and printf "%2d: %3d! + 1 = %s\n", $limit, $_, abr f +1 if (f +1).is-prime;
    exit if $limit >= 30
}
