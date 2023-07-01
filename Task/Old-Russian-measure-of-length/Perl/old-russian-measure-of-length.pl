sub convert {
    my($magnitude, $unit) = @_;
     my %factor = (
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
    );

    my $base= $magnitude * $factor{$unit};
    my $result .= "$magnitude $unit to:\n";
    for (sort { $factor{$a} <=> $factor{$b} } keys %factor) {
        $result .= sprintf "%10s: %s\n", $_, sigdig($base / $factor{$_}, 5) unless $_ eq $unit
    }
    return $result;
}

sub sigdig {
    my($num,$sig) = @_;
    return $num unless $num =~ /\./;

    $num =~ /([1-9]\d*\.?\d*)/;
    my $prefix = $`;
    my $match  = $&;
    $sig++ if $match =~ /\./;
    my $digits = substr $match, 0, $sig;
    my $nextd  = substr $match, $sig, 1;
    $digits =~ s/(.)$/{1+$1}/e if $nextd > 5;
    return $prefix . $digits;
}

print convert(1,'meter'), "\n\n";
print convert(1,'milia'), "\n";
