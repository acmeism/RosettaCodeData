use nqp;
my $cache := nqp::list_i();
nqp::bindpos_i($cache, 650, 0);
nqp::bindpos_i($cache, 1, 1);
nqp::bindpos_i($cache, 89, 89);

sub Euler92(int $n) {
    $n < 650
	?? nqp::bindpos_i($cache,$n,ids($n))
	!! ids($n)
}

sub ids(int $num --> int) {
    my int $n = $num;
    my int $ten = 10;
    my int $sum = 0;
    my int $t;
    my int $c;
    repeat until $n == 89 or $n == 1 {
	$sum = 0;
	repeat {
	    $t = nqp::div_i($n, $ten);
	    $c = $n - $t * $ten;
	    $sum = $sum + $c * $c;
	} while $n = $t;
	$n = nqp::atpos_i($cache,$sum) || $sum;
    }
    $n;
}

my int $cnt = 0;
for 1 .. 100_000_000 -> int $n {
   $cnt = $cnt + 1 if Euler92($n) == 89;
}
say $cnt;
