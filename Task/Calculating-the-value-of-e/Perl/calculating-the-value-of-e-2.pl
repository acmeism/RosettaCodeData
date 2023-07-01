use bigrat;
use Math::Decimal qw(dec_canonise dec_mul dec_rndiv_and_rem);

sub factorial { my $n = 1; $n *= $_ for 1..shift; $n }

for $n (0..70) {
   $sum += 1/factorial($n);
}

($num,$den) = $sum =~ m#(\d+)/(\d+)#;
print "numerator:   $num\n";
print "denominator: $den\n";

$num_dec = dec_canonise($num);
$den_dec = dec_canonise($den);
$ten     = dec_canonise("10");

($q, $r) = dec_rndiv_and_rem("FLR", $num_dec, $den_dec);
$e = "$q.";
for (1..100) {
    $num_dec = dec_mul($r, $ten);
    ($q, $r) = dec_rndiv_and_rem("FLR", $num_dec, $den_dec);
    $e .= $q;
}

printf "\n%s\n", subset $e, 0,102;
