use bignum qw(e);

$e = 2;
$f = 1;
do {
    $e0 = $e;
    $n++;
    $f *= 2*$n * (1 + 2*$n);
    $e += (2*$n + 2) / $f;
} until ($e-$e0) < 1.0e-39;

print "Computed " . substr($e, 0, 41), "\n";
print "Built-in " . e, "\n";
