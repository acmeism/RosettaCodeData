# based on http://www.mathpropress.com/stan/bibliography/spigot.pdf

sub stream(&next, &safe, &prod, &cons, $z is copy, @x) {
    my $x-list = @x.iterator.list;
    gather loop {
        my $y = next($z);
        if safe($z, $y) {
            take $y;
            $z = prod($z, $y);
        } else {
            $z = cons($z, $x-list.shift);
        }
    }
}

sub extr([$q, $r, $s, $t], $x) {
    ($q * $x + $r) div ($s * $x + $t);
}

my $unit = [1, 0, 0, 1];

sub comp([$q,$r,$s,$t], [$u,$v,$w,$x]) {
    [$q * $u + $r * $w,
     $q * $v + $r * $x,
     $s * $u + $t * $w,
     $s * $v + $t * $x];
}

sub pi-stream() {
    stream -> $z { extr($z, 3) },
           -> $z, $n { $n == extr($z, 4) },
           -> $z, $n { comp([10, -10*$n, 0, 1], $z) },
           &comp,
           $unit,
           (1..*).map: { [$_, 4 * $_ + 2, 0, 2 * $_ + 1] }
}

my @pi := pi-stream;

print @pi[0], '.';
print @pi[$_] for 1..*;
