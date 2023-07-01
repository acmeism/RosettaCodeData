use ntheory qw(is_prime);

$i = 42;
while ($n < 42) {
    if (is_prime($i)) {
        $n++;
        printf "%2d %21s\n", $n, commatize($i);
        $i += $i - 1;
    }
    $i++;
}

sub commatize {
    (my $s = reverse shift) =~ s/(.{3})/$1,/g;
    $s =~ s/,$//;
    $s = reverse $s;
}
