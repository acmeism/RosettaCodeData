0e fvalue px
0e fvalue py
fvariable x 0.1e x F!
fvariable y -1e y F!

1e-6 fvalue EPSILON

: fep EPSILON FSQRT ;


: MYFUN   ( x y  -- fxy )
    FDUP FROT FDUP ( y y x x )
    ( x ) 1e F- FDUP F*   ( y y x a )
    FROT ( y x a y )
    ( y ) FDUP F* FNEGATE FEXP F* ( y x b )
    FROT ( x b y )
    ( y ) FDUP 2e F+ F* (  x b c )
    FROT ( b c x )
    ( x ) FDUP F* -2e F* FEXP F*
    F+
;


: xd ( x y )
    to py to px
    px 1e  fep F+ F* py  myfun px 1e fep F- F*  py myfun F- 2e px F* fep F* F/
;

: xy ( x y )
    to py to px
    py 1e  fep F+ F* px FSWAP myfun py 1e fep F- F*  px FSWAP myfun F- 2e py F* fep F* F/
;


: GDB ( x y n -- ) \ gradient descent, initial guess and number of iterations
       CR FOVER FOVER y F! x F!
    0 do
	FOVER FOVER
	 xd 0.3e F* x F@ FSWAP F- x F!
	 xy 0.3e F* y F@ FSWAP F- y F!
	x F@ y F@ FOVER FOVER FSWAP F. F.  CR
    loop
;	
