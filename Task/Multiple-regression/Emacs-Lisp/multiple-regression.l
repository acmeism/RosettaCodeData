(setq X1 '[0 1 2 3 4 5 6 7 8 9 10])
(setq X2 '[0 1 1 3 3 7 6 7 3 9 8])
(setq Y '[1 6 17 34 57 86 121 162 209 262 321])
(calc-eval
 (format "fit(a*X1+b*X2+c,[X1,X2],[a,b,c],[%s %s %s])" X1 X2 Y))
