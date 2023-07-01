\ in Forth, you do many things on your own. This word is used to define 2D arrays
: 2D-ARRAY ( height width )
	CREATE DUP ,
	* CELLS ALLOT
	DOES> ( y x baseaddress )
		ROT    ( x baseaddress y )
		OVER @ ( x baseaddress y width )
		*      ( x baseaddress y*width )
		ROT    ( baseaddress y*width x )
		+ 1+ CELLS +
;

require random.fs
HERE SEED !

0 CONSTANT D-INVALID
1 CONSTANT D-UP
2 CONSTANT D-DOWN
3 CONSTANT D-LEFT
4 CONSTANT D-RIGHT

4 CONSTANT NROWS
4 CONSTANT NCOLS

NROWS NCOLS * CONSTANT GRIDSIZE
NROWS NCOLS 2D-ARRAY GRID
CREATE HAVE-MOVED CELL ALLOT
CREATE TOTAL-SCORE CELL ALLOT
CREATE MOVE-SCORE CELL ALLOT

: DIE-DIRECTIONCONST ." Unknown direction constant:" . BYE ;
: ESC #ESC EMIT ;
: CLS
	ESC ." [2J"
	ESC ." [H"
;

: GRID-VALUE 1 SWAP LSHIFT ;
: DASHES 0 ?DO [CHAR] - EMIT LOOP ;

: DRAW ( -- )
	CLS ." Score: "
	TOTAL-SCORE @ 0 U.R
	MOVE-SCORE  @ ?DUP IF
		."  (+" 0 U.R ." )"
	THEN
	CR 25 DASHES CR

	NROWS 0 ?DO
		." |"
		NCOLS 0 ?DO
			J I GRID @ ?DUP IF
				GRID-VALUE 4 U.R
			ELSE
				4 SPACES
			THEN
			."  |"
		LOOP
		CR
	LOOP

	25 DASHES CR
;

: COUNT-FREE-SPACES ( -- free-spaces )
	0 ( count )
	NROWS 0 ?DO
		NCOLS 0 ?DO
			J I GRID @ 0= IF 1+ THEN
		LOOP
	LOOP
;

: GET-FREE-SPACE ( index -- addr )
	0 0 GRID SWAP ( curr-addr index )
	0 0 GRID @ 0<> IF 1+ THEN
	0 ?DO ( find the next free space index times )
		BEGIN
			CELL+ DUP @ 0=
		UNTIL
	LOOP
;

: NEW-BLOCK ( -- )
	COUNT-FREE-SPACES
	DUP 0<= IF DROP EXIT THEN
	RANDOM GET-FREE-SPACE
	10 RANDOM 0= IF 2 ELSE 1 THEN SWAP !
;

: 2GRID ( a-y a-x b-y b-x -- a-addr b-addr ) GRID -ROT GRID SWAP ;
: CAN-MERGE ( dest-addr other-addr -- can-merge? )
	@ SWAP @ ( other-val dest-val )
	DUP 0<> -ROT = AND
;

: CAN-GRAVITY ( dest-addr other-addr -- can-gravity? )
	@ SWAP @ ( other-val dest-val )
	0= SWAP 0<> AND
;

: TRY-MERGE ( dest-y dest-x other-y other-x -- )
	2GRID ( dest-addr other-addr )
	2DUP CAN-MERGE IF
		TRUE HAVE-MOVED !
		0 SWAP ! ( dest-addr )
		DUP @ 1+ DUP ( dest-addr dest-val dest-val )
		ROT ! ( dest-val )
		GRID-VALUE DUP ( score-diff score-diff )
		MOVE-SCORE +!
		TOTAL-SCORE +!
	ELSE
		2DROP
	THEN
;

: TRY-GRAVITY ( did-something-before operator dest-y dest-x other-y other-x -- did-something-after operator )
	2GRID ( ... dest-addr other-addr )
	2DUP CAN-GRAVITY IF
		TRUE HAVE-MOVED !
		DUP @ ( ... dest-addr other-addr other-val )
		ROT ( ... other-addr other-val dest-addr ) ! ( ... other-addr )
		0 SWAP !
		NIP TRUE SWAP
	ELSE
		2DROP
	THEN
;

: TRY-LOST? ( lost-before operator dy dx oy ox -- lost-after operator )
	2GRID CAN-MERGE INVERT ( lost-before operator lost-now )
	ROT AND SWAP ( lost-after operator )
;

: MOVEMENT-LOOP ( direction operator -- ) CASE
	SWAP
	D-UP OF NROWS 1- 0 ?DO
		NCOLS 0 ?DO
			J I J 1+ I 4 PICK EXECUTE
		LOOP
	LOOP ENDOF
	D-DOWN OF 1 NROWS 1- ?DO
		NCOLS 0 ?DO
			J I J 1- I 4 PICK EXECUTE
		LOOP
	-1 +LOOP ENDOF
	D-LEFT OF NCOLS 1- 0 ?DO
		NROWS 0 ?DO
			I J I J 1+ 4 PICK EXECUTE
		LOOP
	LOOP ENDOF
	D-RIGHT OF 1 NCOLS 1- ?DO
		NROWS 0 ?DO
			I J I J 1- 4 PICK EXECUTE
		LOOP
	-1 +LOOP ENDOF
	DIE-DIRECTIONCONST
ENDCASE DROP ;

: MERGE ( move -- ) ['] TRY-MERGE MOVEMENT-LOOP ;
: GRAVITY-ONCE ( move -- success? ) FALSE SWAP ['] TRY-GRAVITY MOVEMENT-LOOP ;
: GRAVITY ( move -- )
	BEGIN
		DUP GRAVITY-ONCE INVERT
	UNTIL DROP
;

: MOVE-LOST? ( move -- lost? ) TRUE SWAP ['] TRY-LOST? MOVEMENT-LOOP ;
: END-IF-LOST ( -- lost? )
	COUNT-FREE-SPACES 0= IF
		TRUE
		5 1 DO I MOVE-LOST? AND LOOP
		IF ." You lose!" CR BYE THEN
	THEN
;

: END-IF-WON ( -- )
	NROWS 0 ?DO
		NCOLS 0 ?DO
			J I GRID @ GRID-VALUE 2048 = IF ." You win!" CR BYE THEN
		LOOP
	LOOP
;

: TICK ( move -- )
	FALSE HAVE-MOVED !
	0 MOVE-SCORE !
	DUP GRAVITY DUP MERGE GRAVITY
	HAVE-MOVED @ IF NEW-BLOCK DRAW THEN
	END-IF-WON
	END-IF-LOST
;

: GET-MOVE ( -- move )
	BEGIN
		KEY CASE
			#EOF OF BYE ENDOF
			#ESC OF BYE ENDOF
			[CHAR] q OF BYE ENDOF
			[CHAR] Q OF BYE ENDOF
			[CHAR] k OF D-UP TRUE ENDOF
			[CHAR] K OF D-UP TRUE ENDOF
			[CHAR] j OF D-DOWN TRUE ENDOF
			[CHAR] J OF D-DOWN TRUE ENDOF
			[CHAR] h OF D-LEFT TRUE ENDOF
			[CHAR] H OF D-LEFT TRUE ENDOF
			[CHAR] l OF D-RIGHT TRUE ENDOF
			[CHAR] L OF D-RIGHT TRUE ENDOF
			FALSE SWAP
		ENDCASE
	UNTIL
;

: INIT ( -- )
	NROWS 0 ?DO
		NCOLS 0 ?DO
			0 J I GRID !
		LOOP
	LOOP

	0 TOTAL-SCORE !
	0 MOVE-SCORE !
	NEW-BLOCK
	NEW-BLOCK
	DRAW
;

: MAIN-LOOP ( -- )
	BEGIN
		GET-MOVE TICK
	AGAIN
;

INIT
MAIN-LOOP
