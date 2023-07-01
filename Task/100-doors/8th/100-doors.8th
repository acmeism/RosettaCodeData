\ Array of doors; init to empty; accessing a non-extant member will return
\ 'null', which is treated as 'false', so we don't need to initialize it:
[] var, doors

\ given a door number, get the value and toggle it:
: toggle-door \ n --
	doors @ over a:@
	not rot swap a:! drop ;

\ print which doors are open:
: .doors
	(
		doors @ over a:@ nip
		if . space else drop then
	) 1 100 loop ;

\ iterate over the doors, skipping 'n':
: main-pass \ n --
	0
	true
	repeat
		drop
		dup toggle-door
		over n:+
		dup 101 <
	while 2drop drop ;

\ calculate the first 100 doors:
' main-pass 1 100 loop
\ print the results:
.doors cr bye
