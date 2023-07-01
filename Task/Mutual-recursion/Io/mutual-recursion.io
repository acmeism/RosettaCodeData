f := method(n, if( n == 0, 1, n - m(f(n-1))))
m := method(n, if( n == 0, 0, n - f(m(n-1))))

Range
0 to(19) map(n,f(n)) println
0 to(19) map(n,m(n)) println
