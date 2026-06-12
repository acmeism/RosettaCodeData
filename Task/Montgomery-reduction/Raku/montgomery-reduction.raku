sub montgomery-reduce($m, $a is copy) {
    for 0..$m.msb {
        $a += $m if $a +& 1;
        $a +>= 1
    }
    $a % $m
}

my $m  = 750791094644726559640638407699;
my $t1 = 323165824550862327179367294465482435542970161392400401329100;

my $r1 = 440160025148131680164261562101;
my $r2 = 435362628198191204145287283255;

my $x1 = 540019781128412936473322405310;
my $x2 = 515692107665463680305819378593;

say "Original x1:       ", $x1;
say "Recovered from r1: ", montgomery-reduce($m, $r1);
say "Original x2:       ", $x2;
say "Recovered from r2: ", montgomery-reduce($m, $r2);

print "\nMontgomery  computation x1**x2 mod m: ";
my $prod = montgomery-reduce($m, $t1/$x1);
my $base = montgomery-reduce($m, $t1);

for $x2, {$_ +> 1} ... 0 -> $exponent {
    $prod = montgomery-reduce($m, $prod * $base) if $exponent +& 1;
    $base = montgomery-reduce($m, $base * $base);
}

say montgomery-reduce($m, $prod);
say "Built-in op computation x1**x2 mod m: ", $x1.expmod($x2, $m);
