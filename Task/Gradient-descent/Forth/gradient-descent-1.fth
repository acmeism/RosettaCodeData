0e fvalue px
0e fvalue py
fvariable x 0.1e x F!
fvariable y -1e y F!

: ^2 FDUP F* ;

\ gradient for x, analytical function

: GD1 ( F: x y  -- dfxy)
    to py to px
    2e px 1e F- F* py ^2 FNEGATE FEXP F*
    -4e px F* py  F* py 2e F+ F* px ^2 -2e F* FEXP F*
    F+
;

\ gradient for y, analytical function

: GD2 ( F: x y -- dfxy )
    to py to px
    px ^2 -2e F* FEXP FDUP
    py F* FSWAP
    py 2e F+ F* F+
    py ^2 FNEGATE FEXP py F*
    px 1e F- ^2 F*
    -2e F*
    F+
;

\ gradient descent

: GD ( x y n  -- ) \ gradient descent, initial guess and number of iterations
    FOVER FOVER y F! x F!
    0 do
	FOVER FOVER
	GD1 0.3e F* x F@ FSWAP F- x F!
	GD2 0.3e F* y F@ FSWAP  F- y F!
	x F@ y F@ FOVER FOVER FSWAP F. F.  CR
    loop
;

