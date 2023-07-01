convert(1, 'meter');

say '*' x 40, "\n";

convert(1, 'milia');

sub convert (Real $magnitude, $unit) {
     my %factor =
        tochka     => 0.000254,
        liniya     => 0.00254,
        diuym      => 0.0254,
        vershok    => 0.04445,
        piad       => 0.1778,
        fut        => 0.3048,
        arshin     => 0.7112,
        sazhen     => 2.1336,
        versta     => 1066.8,
        milia      => 7467.6,
        centimeter => 0.01,
        meter      => 1.0,
        kilometer  => 1000.0,
    ;

    my $meters = $magnitude * %factor{$unit.lc};

    say "$magnitude $unit to:\n", '_' x 40;

    printf "%10s: %s\n", $_,  $meters / %factor{$_} unless $_ eq $unit.lc
      for %factor.keys.sort:{ +%factor{$_} }
}
