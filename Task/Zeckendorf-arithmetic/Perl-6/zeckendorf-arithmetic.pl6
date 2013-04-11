my $z1 = '1'; # glyph to use for a '1'
my $z0 = '0'; # glyph to use for a '0'

# helper sub to translate constants into the particular glyphs you used
sub z($a) { $a.trans([<1 0>] => [$z1, $z0]) };

######## Zeckendorf comparison operators #########

# less than
sub infix:<ltz>($a, $b) { ($z0 lt $z1) ?? ($a lt $b) !!
    ($a.trans([$z1, $z0] => [<1 0>]) lt $b.trans([$z1, $z0] => [<1 0>]))
};

# greater than
sub infix:<gtz>($a, $b) { ($z0 lt $z1) ?? ($a gt $b) !!
    ($a.trans([$z1, $z0] => [<1 0>]) gt $b.trans([$z1, $z0] => [<1 0>]))
};

# equal
sub infix:<eqz>($a, $b) { $a eq $b };

# not equal
sub infix:<nez>($a, $b) { $a ne $b };


######## Operators for Zeckendorf arithmetic ########

# post increment
sub postfix:<++z>($a is rw) {
    $a = ("$z0$z0"~$a).subst(/("$z0$z0")($z1+ %% $z0)?$/, -> $/ { "$z0$z1" ~ $z0 x $1.chars });
    $a ~~ s/^$z0+//;
    $a
}

# post decrement
sub postfix:<--z>($a is rw) {
    $a.=subst(/$z1($z0*)$/, -> $/ {$z0 ~ "$z1$z0" x $0.chars div 2 ~ $z1 x $0.chars mod 2});
    $a ~~ s/^$z0+(.+)$/$0/;
    $a
}

# addition
sub infix:<+z>($a is copy, $b is copy) { $a++z while $b--z nez $z0; $a };

# subtraction
sub infix:<-z>($a is copy, $b is copy) { $a--z while $b--z nez $z0; $a };

# multiplication
sub infix:<*z>($a, $b) {
    return $z0 if $a eq $z0 or $b eq $z0;
    return $a if $b eq $z1;
    return $b if $a eq $z1;
    my $c = $a;
    my $d = $z1;
    repeat {
         my $e = $z0;
         repeat { $c++z; $e++z } until $e eqz $a;
         $d++z;
    } until $d eqz $b;
    $c
};

# division  (really more of a div mod)
sub infix:</z>($a is copy, $b is copy) {
    fail "Divide by zero" if $b eqz $z0;
    return $a if $a eqz $z0 or $b eqz $z1;
    my $c = $z0;
    repeat {
        my $d = $b +z ($z1 ~ $z0);
        $c++z;
        $a--z while $d--z nez $z0
    } until $a ltz $b;
    $c ~= " remainder $a" if $a nez $z0;
    $c
};


###################### Testing ######################

say "Using the glyph '$z1' for 1 and '$z0' for 0\n";

my $fmt = "%-22s = %15s  %s\n";

my $zeck = $z1;

printf( $fmt, "$zeck++z", $zeck++z, '# increment' ) for 1 .. 10;

printf $fmt, "$zeck +z {z('1010')}", $zeck +z= z('1010'), '# addition';

printf $fmt, "$zeck -z {z('100')}", $zeck -z= z('100'), '# subtraction';

printf $fmt, "$zeck *z {z('100101')}", $zeck *z= z('100101'), '# multiplication';

printf $fmt, "$zeck /z {z('100')}", $zeck /z= z('100'), '# division';

printf( $fmt, "$zeck--z", $zeck--z, '# decrement' ) for 1 .. 5;

printf $fmt, "$zeck *z {z('101001')}", $zeck *z= z('101001'), '# multiplication';

printf $fmt, "$zeck /z {z('100')}", $zeck /z= z('100'), '# division';
