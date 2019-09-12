use MONKEY-SEE-NO-EVAL;

sub leftrect(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    $h * [+] do f($_) for $a, $a+$h ... $b-$h;
}

sub rightrect(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    $h * [+] do f($_) for $a+$h, $a+$h+$h ... $b;
}

sub midrect(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    $h * [+] do f($_) for $a+$h/2, $a+$h+$h/2 ... $b-$h/2;
}

sub trapez(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    my $partial-sum += f($_) * 2 for $a+$h, $a+$h+$h ... $b-$h;
    $h / 2 * [+] f($a), f($b), $partial-sum;
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

sub integrate($f, $a, $b, $n, $exact) {
    my @r0;
    my $e = 0.000001;
    @r0.push: "$f\n   in [$a..$b] / $n\n";
    @r0.push: '             exact result: '~ $exact.round($e);

    my (@r1,@r2,@r3,@r4,@r5);
    my &f;
    EVAL "&f = $f";
    my $p1 = Promise.start( { @r1.push: '     rectangle method left: '~  leftrect(&f, $a, $b, $n).round($e) } );
    my $p2 = Promise.start( { @r2.push: '    rectangle method right: '~ rightrect(&f, $a, $b, $n).round($e) } );
    my $p3 = Promise.start( { @r3.push: '      rectangle method mid: '~   midrect(&f, $a, $b, $n).round($e) } );
    my $p4 = Promise.start( { @r4.push: 'composite trapezoidal rule: '~    trapez(&f, $a, $b, $n).round($e) } );
    my $p5 = Promise.start( { @r5.push: '   quadratic simpsons rule: '~  simpsons(&f, $a, $b, $n).round($e) } );

    await $p1, $p2, $p3, $p4, $p5;
    @r0, @r1, @r2, @r3, @r4, @r5;
}

.say for integrate '{ $_ ** 3 }', 0,     1,       100,       0.25; say '';
.say for integrate '1 / *',       1,   100,      1000,   log(100); say '';
.say for integrate '*.self',      0, 5_000, 5_000_000, 12_500_000; say '';
.say for integrate '*.self',      0, 6_000, 6_000_000, 18_000_000;
