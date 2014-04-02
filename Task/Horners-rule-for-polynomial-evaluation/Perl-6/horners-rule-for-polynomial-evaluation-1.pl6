sub horner ( @coeffs, $x ) {
    @coeffs.reverse.reduce: { $^a * $x + $^b };
}

say horner( [ -19, 7, -4, 6 ], 3 );
