my @units =
    { code => 'd', name => 'degrees' , number =>  360 },
    { code => 'g', name => 'gradians', number =>  400 },
    { code => 'm', name => 'mills'   , number => 6400 },
    { code => 'r', name => 'radians' , number =>  tau },
;

my Code %cvt = (@units X @units).map: -> ($a, $b) {
    "{$a.<code>}2{$b.<code>}" => sub ($angle) {
        my $norm = $angle % $a.<number>
                 - ( $a.<number> if $angle < 0 );
        $norm * $b.<number> / $a.<number>
    }
}

say '     Angle Unit     ', @units».<name>».tc.fmt('%11s');

for -2, -1, 0, 1, 2, tau, 16, 360/tau, 360-1, 400-1, 6400-1, 1_000_000 -> $angle {
    say '';
    for @units -> $from {
        my @sub_keys = @units.map: { "{$from.<code>}2{.<code>}" };

        my @results = %cvt{@sub_keys}».($angle);

        say join ' ', $angle      .fmt('%10g'),
                      $from.<name>.fmt('%-8s'),
                      @results    .fmt('%11g');
    }
}
