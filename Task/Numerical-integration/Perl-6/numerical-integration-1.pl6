sub leftrect(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    $h * [+] do f($_) for $a, *+$h ... $b-$h;
}

sub rightrect(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    $h * [+] do f($_) for $a+$h, *+$h ... $b;
}

sub midrect(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    $h * [+] do f($_) for $a+$h/2, *+$h ... $b-$h/2;
}

sub trapez(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    $h / 2 * [+] f($a), f($b), do f($_) * 2 for $a+$h, *+$h ... $b-$h;
}

sub simpsons(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    my $h2 = $h/2;
    my $sum1 = f($a + $h2);
    my $sum2 = 0;

    for $a+$h, *+$h ... $b-$h {
        $sum1 += f($_ + $h2);
        $sum2 += f($_);
    }
    ($h / 6) * (f($a) + f($b) + 4*$sum1 + 2*$sum2);
}

sub tryem($f, $a, $b, $n, $exact) {
    say "\n$f\n   in [$a..$b] / $n";
    eval "my &f = $f;
    say '              exact result: ', $exact;
    say '     rectangle method left: ', leftrect  &f, $a, $b, $n;
    say '    rectangle method right: ', rightrect &f, $a, $b, $n;
    say '      rectangle method mid: ', midrect   &f, $a, $b, $n;
    say 'composite trapezoidal rule: ', trapez    &f, $a, $b, $n;
    say '   quadratic simpsons rule: ', simpsons  &f, $a, $b, $n;"
}

tryem '{ $_ ** 3 }', 0, 1, 100, 0.25;

tryem '1 / *', 1, 100, 1000, log(100);

tryem '{$_}', 0, 5_000, 10_000, 12_500_000;

tryem '{$_}', 0, 6_000, 12_000, 18_000_000;
