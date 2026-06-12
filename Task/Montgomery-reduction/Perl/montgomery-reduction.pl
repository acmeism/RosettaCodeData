use bigint;
use ntheory qw(powmod);

sub msb {
  my ($n, $base) = (shift, 0);
  $base++ while $n >>= 1;
  $base;
}

sub montgomery_reduce {
    my($m, $a) = @_;
    for (0 .. msb($m)) {
        $a += $m if $a & 1;
        $a >>= 1
    }
    $a % $m
}

my $m  = 750791094644726559640638407699;
my $t1 = 323165824550862327179367294465482435542970161392400401329100;

my $r1 = 440160025148131680164261562101;
my $r2 = 435362628198191204145287283255;

my $x1 = 540019781128412936473322405310;
my $x2 = 515692107665463680305819378593;

printf "Original x1:       %s\n", $x1;
printf "Recovered from r1: %s\n", montgomery_reduce($m, $r1);
printf "Original x2:       %s\n", $x2;
printf "Recovered from r2: %s\n", montgomery_reduce($m, $r2);

print "\nMontgomery  computation x1**x2 mod m: ";
my $prod = montgomery_reduce($m, $t1/$x1);
my $base = montgomery_reduce($m, $t1);

for (my $exponent = $x2; $exponent >= 0; $exponent >>= 1) {
    $prod = montgomery_reduce($m, $prod * $base) if $exponent & 1;
    $base = montgomery_reduce($m, $base * $base);
    last if $exponent == 0;
}

print montgomery_reduce($m, $prod) . "\n";
printf "Built-in op computation x1**x2 mod m: %s\n", powmod($x1, $x2, $m);
