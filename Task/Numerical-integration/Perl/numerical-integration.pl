use feature 'say';

sub leftrect {
    my($func, $a, $b, $n) = @_;
    my $h = ($b - $a) / $n;
    my $sum = 0;
    for ($_ = $a; $_ < $b; $_ += $h) { $sum += $func->($_) }
    $h * $sum
}

sub rightrect {
    my($func, $a, $b, $n) = @_;
    my $h = ($b - $a) / $n;
    my $sum = 0;
    for ($_ = $a+$h; $_ < $b+$h; $_ += $h) { $sum += $func->($_) }
    $h * $sum
}

sub midrect {
    my($func, $a, $b, $n) = @_;
    my $h = ($b - $a) / $n;
    my $sum = 0;
    for ($_ = $a + $h/2; $_ < $b; $_ += $h) { $sum += $func->($_) }
    $h * $sum
}

sub trapez {
    my($func, $a, $b, $n) = @_;
    my $h = ($b - $a) / $n;
    my $sum = $func->($a) + $func->($b);
    for ($_ = $a+$h; $_ < $b; $_ += $h) { $sum += 2 * $func->($_) }
    $h/2 * $sum
}
sub simpsons {
    my($func, $a, $b, $n) = @_;
    my $h = ($b - $a) / $n;
    my $h2 = $h/2;
    my $sum1 = $func->($a + $h2);
    my $sum2 = 0;

    for ($_ = $a+$h; $_ < $b; $_ += $h) {
        $sum1 += $func->($_ + $h2);
        $sum2 += $func->($_);
    }
    $h/6 * ($func->($a) + $func->($b) + 4*$sum1 + 2*$sum2)
}

# round where needed, display in a reasonable format
sub sig {
    my($value) = @_;
    my $rounded;
    if ($value < 10) {
        $rounded = sprintf '%.6f', $value;
        $rounded =~ s/(\.\d*[1-9])0+$/$1/;
        $rounded =~ s/\.0+$//;
    } else {
        $rounded = sprintf "%.1f", $value;
        $rounded =~ s/\.0+$//;
    }
    return $rounded;
}

sub integrate {
    my($func, $a, $b, $n, $exact) = @_;

    my $f = sub { local $_ = shift; eval $func };

    my @res;
    push @res, "$func\n   in [$a..$b] / $n";
    push @res, '              exact result: ' . rnd($exact);
    push @res, '     rectangle method left: ' . rnd( leftrect($f, $a, $b, $n));
    push @res, '    rectangle method right: ' . rnd(rightrect($f, $a, $b, $n));
    push @res, '      rectangle method mid: ' . rnd(  midrect($f, $a, $b, $n));
    push @res, 'composite trapezoidal rule: ' . rnd(   trapez($f, $a, $b, $n));
    push @res, '   quadratic simpsons rule: ' . rnd( simpsons($f, $a, $b, $n));
    @res;
}
say for integrate('$_ ** 3', 0, 1, 100, 0.25); say '';
say for integrate('1 / $_', 1, 100, 1000, log(100)); say '';
say for integrate('$_', 0, 5_000, 5_000_000, 12_500_000); say '';
say for integrate('$_', 0, 6_000, 6_000_000, 18_000_000);
