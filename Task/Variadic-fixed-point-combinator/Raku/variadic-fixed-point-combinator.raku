# 20240726 Raku programming solution

my &Y = -> \a { a.map: -> \f { -> &x { -> { x(Y(a)) } }(f) } }

my \even_odd_fix = -> \f { -> \n { n == 0  or f[1]()(n - 1) } },
                   -> \f { -> \n { n != 0 and f[0]()(n - 1) } };

my \collatz_fix = -> \f { -> \n, \d { n == 1 ?? d !! f[(n % 2)+1]()(n, d+1) } },
                  -> \f { -> \n, \d { f[0]()( n div 2, d ) } },
                  -> \f { -> \n, \d { f[0]()(   3*n+1, d ) } };

my \even_odd = Y(even_odd_fix).map: -> &f { f() }; # or { $_() }
my &collatz  = Y(collatz_fix)[0]();

for 1..10 -> \i {
   my ( \e, \o, \c ) = even_odd[0](i), even_odd[1](i), collatz(i, 0);
   printf "%2d: Even: %s  Odd: %s  Collatz: %s\n", i, e, o, c
}
