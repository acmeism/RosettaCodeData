 1 0 0 0                                                          \ pushes orientation of the ant to the stack.

 100 CONSTANT border                                              \ lenght of the side of the grid
 border border * constant size                                    \ size of the grid

 variable antpos                                                  \ for storing position of the ant
 size 2 / border 2 / +  antpos !                                  \ positions ant in the middle of the grid

 create Grid size cells allot
 here constant GridEnd                                            \ creates an array to hold the grid

 : turn.left
	>r rot r> SWAP ;                                          \ rotates ant anti-clockwise

 : turn.right
	turn.left turn.left turn.left ;                           \ rotates ant clockwise

 : stop.ant
	antpos @ DUP 0<  SWAP size > + ;                          \ checks if ant not out of bounds

 : call.pos
	Grid antpos @ cells + @ ;                                 \ pushes ant position to the stack

 : grid.add
	Grid antpos @ cells + @ -1 + Grid antpos @ cells + !   ;  \ pushes -1 to the current position of the ant on the grid
	
 : swap.pos
	call.pos dup * Grid antpos @ cells + ! ;                  \ multiplies current grid cell by itself to turn -1 into 1

 : swap.col
	grid.add swap.pos ;                                       \ changes current grid cell color

 : go.ant                                                         \ moves ant one step in the direction taken from the stack
	2over 2over                                               \ copies stack for testing
	1 = IF antpos @ border + antpos ! 2DROP DROP ELSE         \ if true moves ant one cell up, drops unused numbers from stack
	1 = IF antpos @ 1 + antpos ! 2DROP ELSE                   \ same, but moves to the right
	1 = IF antpos @ border - antpos ! DROP ELSE               \ here to the left
	1 = IF antpos @ 1 - antpos ! ELSE                         \ and down

	THEN THEN THEN THEN  ;
	
 : step.ant                                                       \ preforms one full step.
	 call.pos 1 = IF turn.left swap.col ELSE
	 turn.right swap.col
	
	 THEN go.ant  ;
	
 : run.ant                                                        \ runs the ant until it leaves the grid
	BEGIN
	step.ant
	stop.ant UNTIL ;
	
 : square.draw                                                     \ draws an "*" if grid cell is one or " " if zero
	1 = IF 42 EMIT ELSE 32 EMIT THEN ;
		
	
 : draw.grid                                                       \ draws grid on screen
	PAGE                                                       \ clear sreen
	size 0 DO I
	I border MOD 0= IF  CR  THEN                               \ breaks the grid into lines
	Grid I cells + @ square.draw DROP
	
	LOOP ;
	
 : langton.ant run.ant draw.grid ;                                 \ launches the ant, outputs the result
