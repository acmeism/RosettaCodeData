my @primorials = 1, |[\*] (2..*).grep: &is-prime;
sub abr ($_) { .chars < 41 ?? $_ !! .substr(0,20) ~ '..' ~ .substr(*-20) ~ " ({.chars} digits)" }

my $limit;

for ^∞ {
    my \p = @primorials[$_];
    ++$limit and printf "%2d: %5s - 1 = %s\n", $limit, "p$_#", abr p -1 if (p -1).is-prime;
    ++$limit and printf "%2d: %5s + 1 = %s\n", $limit, "p$_#", abr p +1 if (p +1).is-prime;
    exit if $limit >= 30
}
