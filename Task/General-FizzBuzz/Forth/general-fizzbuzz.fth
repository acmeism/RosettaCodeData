\ gfb.fs - generalized fizz buzz
: times		( xt n -- )
	BEGIN dup WHILE
		1- over swap 2>r execute 2r>
	REPEAT
	2drop
;
\ 'Domain Specific Language' compiling words
\ -- First  comment: stack-effect at compile-time
\ -- Second comment: stack efect of compiled sequence
: ]+[		( u ca u -- ) ( u f -- u f' )
	2>r >r	]
			]] over [[
	r>  		]] literal mod 0= IF [[
	2r> 		]] sliteral type 1+ THEN [ [[
;
: ]fb		( -- xt ) ( u f -- u+1 )
	]] IF space ELSE dup u. THEN 1+ ; [[
;
: fb[		( -- ) ( u -- u 0  ;'u' is START-NUMBER )
	:noname  0 ]] literal [ [[
;
\ Usage: START-NUMBER COMPILING-SEQUENCE U times drop ( INCREASED-NUBER )
\ Example:
\ 1 fb[ 3 s" fizz" ]+[ 5 s" buzz" ]+[ 7 s" dizz" ]+[ ]fb 40 times drop
