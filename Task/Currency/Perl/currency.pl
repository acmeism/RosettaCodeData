use Math::Decimal qw(dec_canonise dec_add dec_mul dec_rndiv_and_rem);

@check = (
    [<Hamburger 5.50 4000000000000000>],
    [<Milkshake 2.86                2>]
);

my $fmt = "%-10s %8s %18s %22s\n";
printf $fmt, <Item Price Quantity Extension>;

my $subtotal = dec_canonise(0);
for $line (@check) {
    ($item,$price,$quant) = @$line;
    $dp = dec_canonise($price); $dq = dec_canonise($quant);
    my $extension = dec_mul($dp,$dq);
    $subtotal = dec_add($subtotal, $extension);
    printf $fmt, $item, $price, $quant, rnd($extension);
}

my $rate  = dec_canonise(0.0765);
my $tax   = dec_mul($subtotal,$rate);
my $total = dec_add($subtotal,$tax);

printf $fmt, '', '', '',          '-----------------';
printf $fmt, '', '', 'Subtotal ', rnd($subtotal);
printf $fmt, '', '', 'Tax ',      rnd($tax);
printf $fmt, '', '', 'Total ',    rnd($total);

sub rnd {
    ($q, $r) = dec_rndiv_and_rem("FLR", @_[0], 1);
    $q . substr((sprintf "%.2f", $r), 1, 3);
}
