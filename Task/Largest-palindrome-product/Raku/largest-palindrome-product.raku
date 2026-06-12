use Inline::Perl5;
my $p5 = Inline::Perl5.new();
$p5.use: 'ntheory';
my &divisors = $p5.run('sub { ntheory::divisors $_[0] }');

.say for (2..12).map: {.&lpp};

multi lpp ($oom where {!($_ +& 1)}) { # even number of multiplicand digits
    my $f = +(9 x $oom);
    my $o = $oom / 2;
    my $pal = +(9 x $o ~ 0 x $oom ~ 9 x $o);
    sprintf "Largest palindromic product of two %2d-digit integers: %d × %d = %d", $oom, $pal div $f, $f, $pal
}

multi lpp ($oom where {$_ +& 1}) { # odd number of multiplicand digits
    my $p;
    (+(1 ~ (0 x ($oom - 1))) .. +(9 ~ (9 x ($oom - 1)))).reverse.map({ +($_ ~ .flip) }).map: -> $pal {
        for my @factors = divisors("$pal")».Int.grep({ .chars == $oom }).sort( -* ) {
            next unless $pal div $_ ∈ @factors;
            $p = sprintf("Largest palindromic product of two %2d-digit integers: %d × %d = %d", $oom, $pal div $_, $_, $pal);
            last;
        }
        last if $p;
    }
    $p
}
