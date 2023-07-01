INCLUDE ran4.seq

100      CONSTANT #drawers
#drawers CONSTANT #players
100000   CONSTANT #tries

CREATE drawers  #drawers CELLS ALLOT                    \ index 0..#drawers-1

: drawer[]                              ( n -- addr )   \ return address of drawer n
    CELLS drawers +
;

: random_drawer                         ( -- n )        \ n=0..#drawers-1 random drawer
    RAN4 ( d ) XOR ( n ) #drawers MOD
;

: random_drawer[]                       ( -- addr )     \ return address of random drawer
    random_drawer drawer[]
;

: swap_indirect                         ( addr1 addr2 -- )  \ swaps the values at the two addresses
    2DUP @ SWAP @                       ( addr1 addr2 n2 n1 )
    ROT ! SWAP !                        \ store n1 at addr2 and n2 at addr1
;

: init_drawers                          ( -- ) \ shuffle cards into drawers
    #drawers 0 DO
        I I drawer[] !                  \ store cards in order
    LOOP
    #drawers 0 DO
        I drawer[]  random_drawer[]     ( addr-drawer-i addr-drawer-rnd )
        swap_indirect
    LOOP
;

: random_turn                           ( player - f )
    #drawers 2 / 0 DO
		random_drawer
		drawer[] @
		OVER = IF
			DROP TRUE UNLOOP EXIT	\ found his number
		THEN
	LOOP
	DROP FALSE
;

0 VALUE player

: cycle_turn                            ( player - f )
	DUP TO player			( next-drawer )
    #drawers 2 / 0 DO
		drawer[] @
		DUP player = IF
			DROP TRUE UNLOOP EXIT	\ found his number
		THEN
	LOOP
	DROP FALSE
;

: turn                                  ( strategy player - f )
    SWAP 0= IF                          \ random play
        random_turn
    ELSE
        cycle_turn
    THEN
;

: play                                  ( strategy -- f ) \ return true if prisioners survived
    init_drawers
    #players 0 DO
        DUP I turn
        0= IF
            DROP FALSE UNLOOP EXIT 	\ this player did not survive, UNLOOP, return false
        THEN
    LOOP
    DROP TRUE                           \ all survived, return true
;

: trie					( strategy - nr-saved )
	0				( strategy nr-saved )
	#tries 0 DO
		OVER play IF 1+ THEN
	LOOP
	NIP
;

0 trie . CR	\ random strategy
1 trie . CR	\ follow the card number strategy
