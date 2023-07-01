# Helper subs

sub infix:<reduce> (\prev, \this) { this.key => this.key * (this.value - prev.value) }

sub next-bernoulli ( (:key($pm), :value(@pa)) ) {
    $pm + 1 => [ map *.value, [\reduce] ($pm + 2 ... 1) Z=> 1 / ($pm + 2), |@pa ]
}

constant bernoulli = (0 => [1.FatRat], &next-bernoulli ... *).map: { .value[*-1] };

sub binomial (Int $n, Int $p) { combinations($n, $p).elems }

sub asRat (FatRat $r) { $r ?? $r.denominator == 1 ?? $r.numerator !! $r.nude.join('/') !! 0 }


# The task
sub faulhaber_triangle ($p) { map { binomial($p + 1, $_) * bernoulli[$_] / ($p + 1) }, ($p ... 0) }

# First 10 rows of Faulhaber's triangle:
say faulhaber_triangle($_)».&asRat.fmt('%5s') for ^10;
say '';

# Extra credit:
my $p = 17;
my $n = 1000;
say sum faulhaber_triangle($p).kv.map: { $^value * $n**($^key + 1) }
