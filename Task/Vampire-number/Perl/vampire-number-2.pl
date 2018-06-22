use ntheory qw(sqrtint logint divisors);

sub is_vampire {
    my ($n) = @_;

    return if (length($n) % 2 or $n < 0);

    my $l1 = 10**logint(sqrtint($n), 10);
    my $l2 = sqrtint($n);

    my $s = join('', sort split(//, $n));

    my @fangs;

    foreach my $d (divisors($n)) {

        $d < $l1 and next;
        $d > $l2 and last;

        my $t = $n / $d;

        next if ($d % 10 == 0 and $t % 10 == 0);
        next if (join('', sort split(//, "$d$t")) ne $s);

        push @fangs, [$d, $t];
    }

    return @fangs;
}

print "First 25 Vampire Numbers:\n";

for (my ($n, $i) = (1, 1) ; $i <= 25 ; ++$n) {
    if (my @fangs = is_vampire($n)) {
        printf("%2d. %6s : %s\n", $i++, $n, join(' ', map { "[@$_]" } @fangs));
    }
}

print "\nIndividual tests:\n";

foreach my $n (16758243290880, 24959017348650, 14593825548650) {
    my @fangs = is_vampire($n);
    print("$n: ", (@fangs ? join(' ', map { "[@$_]" } @fangs)
                          : "is not a vampire number"), "\n");
}
