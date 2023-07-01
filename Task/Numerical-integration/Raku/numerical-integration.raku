use MONKEY-SEE-NO-EVAL;

sub leftrect(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    my $end = $b-$h;
    my $sum = 0;
    loop (my $i = $a; $i <= $end; $i += $h) { $sum += f($i) }
    $h * $sum;
}

sub rightrect(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    my $sum = 0;
    loop (my $i = $a+$h; $i <= $b; $i += $h) { $sum += f($i) }
    $h * $sum;
}

sub midrect(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    my $sum = 0;
    my ($start, $end) = $a+$h/2, $b-$h/2;
    loop (my $i = $start; $i <= $end; $i += $h) { $sum += f($i) }
    $h * $sum;
}

sub trapez(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    my $partial-sum = 0;
    my ($start, $end) = $a+$h, $b-$h;
    loop (my $i = $start; $i <= $end; $i += $h) { $partial-sum += f($i) * 2 }
    $h / 2 * ( f($a) + f($b) + $partial-sum );
}

sub simpsons(&f, $a, $b, $n) {
    my $h = ($b - $a) / $n;
    my $h2 = $h/2;
    my ($start, $end) = $a+$h, $b-$h;
    my $sum1 = f($a + $h2);
    my $sum2 = 0;
    loop (my $i = $start; $i <= $end; $i += $h) {
        $sum1 += f($i + $h2);
        $sum2 += f($i);
    }
    ($h / 6) * (f($a) + f($b) + 4*$sum1 + 2*$sum2);
}

sub integrate($f, $a, $b, $n, $exact) {
    my $e = 0.000001;
    my $r0 = "$f\n   in [$a..$b] / $n\n"
        ~ '              exact result: '~ $exact.round($e);

    my ($r1,$r2,$r3,$r4,$r5);
    my &f;
    EVAL "&f = $f";
    my $p1 = Promise.start( { $r1 = '     rectangle method left: '~  leftrect(&f, $a, $b, $n).round($e) } );
    my $p2 = Promise.start( { $r2 = '    rectangle method right: '~ rightrect(&f, $a, $b, $n).round($e) } );
    my $p3 = Promise.start( { $r3 = '      rectangle method mid: '~   midrect(&f, $a, $b, $n).round($e) } );
    my $p4 = Promise.start( { $r4 = 'composite trapezoidal rule: '~    trapez(&f, $a, $b, $n).round($e) } );
    my $p5 = Promise.start( { $r5 = '   quadratic simpsons rule: '~  simpsons(&f, $a, $b, $n).round($e) } );

    await $p1, $p2, $p3, $p4, $p5;
    $r0, $r1, $r2, $r3, $r4, $r5;
}

.say for integrate '{ $_ ** 3 }', 0,     1,       100,       0.25; say '';
.say for integrate '1 / *',       1,   100,      1000,   log(100); say '';
.say for integrate '*.self',      0, 5_000, 5_000_000, 12_500_000; say '';
.say for integrate '*.self',      0, 6_000, 6_000_000, 18_000_000;
