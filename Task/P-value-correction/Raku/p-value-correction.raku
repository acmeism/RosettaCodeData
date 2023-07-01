########################### Helper subs ###########################

sub adjusted (@p, $type) { "\n$type\n" ~ format adjust( check(@p), $type ) }

sub format ( @p, $cols = 5 ) {
    my $i = -$cols;
    my $fmt = "%1.10f";
    join "\n", @p.rotor($cols, :partial).map:
      { sprintf "[%2d]  { join ' ', $fmt xx $_ }", $i+=$cols, $_ };
}

sub check ( @p ) { die 'p-values must be in range 0.0 to 1.0' if @p.min < 0 or 1 < @p.max; @p }

multi ratchet ( 'up', @p ) { my $m; @p[$_] min= $m, $m = @p[$_] for ^@p; @p }

multi ratchet ( 'dn', @p ) { my $m; @p[$_] max= $m, $m = @p[$_] for ^@p .reverse; @p }

sub schwartzian ( @p, &transform, :$ratchet ) {
    my @pa = @p.map( {[$_, $++]} ).sort( -*.[0] ).map: { [transform(.[0]), .[1]] };
    @pa[*;0] = ratchet($ratchet, @pa»[0]);
    @pa.sort( *.[1] )»[0]
}

############# The various p-value correction routines #############

multi adjust( @p, 'Benjamini-Hochberg' ) {
    @p.&schwartzian: * * @p / (@p - $++) min 1, :ratchet('up')
}

multi adjust( @p, 'Benjamini-Yekutieli' ) {
    my \r = ^@p .map( { 1 / ++$ } ).sum;
    @p.&schwartzian: * * r * @p / (@p - $++) min 1, :ratchet('up')
}

multi adjust( @p, 'Hochberg' ) {
    my \m = @p.max;
    @p.&schwartzian: * * ++$ min m, :ratchet('up')
}

multi adjust( @p, 'Holm' ) {
    @p.&schwartzian: * * ++$ min 1, :ratchet('dn')
}

multi adjust( @p, 'Šidák' ) {
    @p.&schwartzian: 1 - (1 - *) ** ++$, :ratchet('dn')
}

multi adjust( @p, 'Bonferroni' ) {
    @p.map: * * @p min 1
}

# Hommel correction can't be easily reduced to a one pass transform
multi adjust( @p, 'Hommel' ) {
    my @s  = @p.map( {[$_, $++]} ).sort: *.[0] ; # sorted
    my \z  = +@p; # array si(z)e
    my @pa = @s»[0].map( * * z / ++$ ).min xx z; # p adjusted
    my @q;        # scratch array
    for (1 ..^ z).reverse -> $i {
        my @L  = 0 .. z - $i; # lower indices
        my @U  = z - $i ^..^ z; # upper indices
        my $q  = @s[@U]»[0].map( { $_ * $i / (2 + $++) } ).min;
        @q[@L] = @s[@L]»[0].map: { min $_ * $i, $q, @s[*-1][0] };
        @pa    = ^z .map: { max @pa[$_], @q[$_] }
    }
    @pa[@s[*;1].map( {[$_, $++]} ).sort( *.[0] )»[1]]
}

multi adjust ( @p, $unknown ) {
    note "\nSorry, do not know how to do $unknown correction.\n" ~
    "Perhaps you want one of these?:\n" ~
    <Benjamini-Hochberg Benjamini-Yekutieli Bonferroni Hochberg
    Holm Hommel Šidák>.join("\n");
    exit
}

########################### The task ###########################

my @p-values =
    4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
    8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
    4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
    8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
    3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
    1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
    4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
    3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
    1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
    2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03
;

for < Benjamini-Hochberg Benjamini-Yekutieli Bonferroni Hochberg Holm Hommel Šidák >
{
    say adjusted @p-values, $_
}
