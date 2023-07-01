use Rat::Precise;

sub continued-fraction($n, :@a, :@b) {
    my $x = @a[0].FatRat;
    $x = @a[$_ - 1] + @b[$_] / $x for reverse 1 ..^ $n;
    $x;
}

#`{ √163 } my $r163 =           continued-fraction( 50, :a(12,|((2*12) xx *)),      :b(19 xx *));
#`{ π    } my $pi   =         4*continued-fraction(140, :a( 0,|(1, 3 ... *)),       :b(4, 1, |((1, 2, 3 ... *) X** 2)));
#`{ e**x } my $R    = 1 + ($_ / continued-fraction(170, :a( 1,|(2+$_, 3+$_ ... *)), :b(Nil,  |(-1*$_, -2*$_ ... *)  ))) given $r163*$pi;

say "Ramanujan's constant to 32 decimal places:\n", $R.precise(32);
