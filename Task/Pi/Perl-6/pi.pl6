# based on http://www.mathpropress.com/stan/bibliography/spigot.pdf

sub stream(&next, &safe, &prod, &cons, $z is copy, @x) {
    gather loop {
        $z = safe($z, my $y = next($z)) ??
             prod($z, take $y)          !!
             cons($z, @x[(state $)++])
    }
}

sub extr([$q, $r, $s, $t], $x) {
    ($q * $x + $r) div ($s * $x + $t)
}

sub comp([$q,$r,$s,$t], [$u,$v,$w,$x]) {
    [$q * $u + $r * $w,
     $q * $v + $r * $x,
     $s * $u + $t * $w,
     $s * $v + $t * $x]
}

my $pi :=
    stream -> $z { extr($z, 3) },
           -> $z, $n { $n == extr($z, 4) },
           -> $z, $n { comp([10, -10*$n, 0, 1], $z) },
           &comp,
           <1 0 0 1>,
           (1..*).map: { [$_, 4 * $_ + 2, 0, 2 * $_ + 1] }

for ^Inf -> $i {
    print $pi[$i];
    once print '.'
}
