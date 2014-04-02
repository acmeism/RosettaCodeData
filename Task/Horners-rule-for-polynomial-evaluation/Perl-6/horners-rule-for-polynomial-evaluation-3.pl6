sub infix:<o>(&f, &g) { -> $x { &f(&g($x)) } }

sub horner ( @c, $x ) {
    [\o] map { -> $u { $_ + $x * $u } }, @c;
}

say map { .(0) }, horner( [ -19, 7, -4, 6 ], 3 );

# compute progressive approximations of exp(2)
my @c := 1 X/ 1, [\*] 1 ... *;

say .(0) for horner( @c, 2 );
