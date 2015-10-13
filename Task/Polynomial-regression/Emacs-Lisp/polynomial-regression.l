(setq x '[0 1 2 3 4 5 6 7 8 9 10])
(setq y '[1 6 17 34 57 86 121 162 209 262 321])
(calc-eval
 (format "fit(a*x^2+b*x+c,[x],[a,b,c],[%s %s])" x y))
