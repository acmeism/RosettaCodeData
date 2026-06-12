my \r = 1/sqrt(2);
my Pair @m = [[
      triple       => [[ 1, -1,  0], [ 0,  1, -1], [ 0,  0,  1] ],
      double       => [[ 2,  0,  0], [ 0, -1,  0], [ 0,  0, -1] ],
      distinct     => [[ 2,  0,  0], [ 0,  3,  4], [ 0,  4,  9] ],
      rotation     => [[ 1,  0,  0], [ 0,  r, -r], [ 0,  r,  r] ],
   ]];
for ^@m {
   my Pair $pair = @m[$_];                  print "\n  {1+$_}:  {$pair.key} ";
   my @t = $pair.value.[];                  say 'matrix: 	  ', @t.raku;
   my @poly = polynomial( @t );             say 'polynomial:  ', @poly.raku;
   my @reduction = reduction( |@poly );     say 'reduction :  ', @reduction.raku;
   my ( $s, $e ) = spectrum( @t );          say 'eigenvalues: ', @$s.raku;
                                            say 'errors: 	  ', @$e.raku;
}
sub horner( \x, \a, \b, \c, \d ) {          # cubic polynomial using horner's method
    ((a * x + b) * x + c) * x + d
}
sub polynomial( @t ) {
    my \a = 1;                                  # create characteristic polynomial
    my \b = -(@t[0;0] + @t[1;1] + @t[2;2]);                     # = -trace
    my \c = ( @t[0;0]*@t[1;1] + @t[1;1]*@t[2;2] + @t[2;2]*@t[0;0] )
            -(@t[1;2]*@t[2;1] + @t[2;0]*@t[0;2] + @t[0;1]*@t[1;0] );
    my \d = - @t[0;0] * @t[1;1] * @t[2;2]
            - @t[0;1] * @t[1;2] * @t[2;0]
            - @t[0;2] * @t[1;0] * @t[2;1]
            + @t[0;0] * @t[2;1] * @t[1;2]
            + @t[0;1] * @t[1;0] * @t[2;2]
            + @t[0;2] * @t[1;1] * @t[2;0];                  # = -determinant
    return [ a, b, c, d]>>.narrow;
}
sub reduction( \a, \b, \c, \d ) {
    my \delta = 18 * a * b * c * d - 4 * b **3 * d + b**2 * c**2 - 4 * a * c**3 - 27 * a**2 * d**2;
    my \p = (3 * a * c - b * b) / (3 * a * a);
    my \q = (2 * b ** 3 - 9 * a * b * c + 27 * a ** 2 * d) / (27 * a ** 3);
    my \d0 = b*b - 3 * a * c;
    my \d1 = 2*b**3 - 9*a*b*c + 27 * a**2 * d;
    return [ delta, p, q, d0, d1 ];
}
sub solution( \a, \b, \c, \d, \delta, \p, \q, \d0, \d1 ) {
    my @x;
    if abs(delta) =~= 0 {           # say " multiple real roots ", p.raku ;
        if abs(p) =~= 0 {           # say " triple equal real roots: ";;
            @x[$_] = 0 for ^3;
        }
        else {                      # say ' double real root:';
            @x[0] = 3 * q / p;
            @x[1] = -3 * q /(2 * p);
            @x[2] = @x[1];
        }
    }
    elsif delta > 0 {               # say " three distinct real roots:";
        @x[$_] = 2*sqrt(-p/3) * cos( acos( sqrt( -3 / p ) * 3 * q /( 2 * p ) )/3 - 2*pi * $_/ 3 ) for ^3;
    }
    else {      # delta < 0;        say " one real root and two complex conjugate roots:";
        my $g = do {
            if d0 == 0 and d1 < 0 {
                -(-d1)**⅓;
            }
            elsif d0 < 0 and d1 == 0 {
                -sqrt(-d0);
            }
            else {
                my \s = Complex( d1**2 - 4 * d0**3 ).sqrt;
                my \g1 = (( d1 + s )/2)**⅓;
                my \g2 = (( d1 - s )/2)**⅓;
                g1 == 0 ?? g2 !! g1
            }
        }
        my Complex $z = $g * ( -1 + Complex(-3).sqrt )/2;
        @x[0] = -⅓ * ( $g + d0 / $g );
        @x[1] = -⅓ * ( $z + d0 / $z );
        @x[2] = @x[1].conj;
    }
    @x[$_] -= ⅓ * b / a for ^3;
    return @x;
}
sub spectrum( @mat ) {
    my ( \a, \b, \c, \d )         = polynomial( @mat );
    my (\delta, \p, \q, \d0, \d1) = reduction( a, b, c, d );
    my @s = solution( a, b, c, d, delta, p, q, d0, d1 )>>.narrow;
    my @e = @s.map( { horner( $_, a, b, c, d ) })>>.narrow;
    return ( @s, @e );
}
