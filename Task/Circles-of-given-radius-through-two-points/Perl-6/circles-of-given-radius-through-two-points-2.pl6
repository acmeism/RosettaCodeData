multi sub circles ($a, $b where $a == $b, 0.0) { 'Degenerate point' }
multi sub circles ($a, $b where $a == $b, $)   { 'Infinitely many share a point' }
multi sub circles ($a, $b, $r) {
    my $h = ($b - $a) / 2;
    my $l = sqrt($r**2 - $h.abs**2);
    return 'Too far apart' if $l.isNaN;
    return map { $a + $h + $l * $_ * $h / $h.abs }, i, -i;
}

my @input =
    (0.1234 + 0.9876i,  0.8765 + 0.2345i,   2.0),
    (0.0000 + 2.0000i,  0.0000 + 0.0000i,   1.0),
    (0.1234 + 0.9876i,  0.1234 + 0.9876i,   2.0),
    (0.1234 + 0.9876i,  0.8765 + 0.2345i,   0.5),
    (0.1234 + 0.9876i,  0.1234 + 0.9876i,   0.0),
    ;

for @input {
    say .join(', '), ': ', circles(|$_).join(' and ');
}
