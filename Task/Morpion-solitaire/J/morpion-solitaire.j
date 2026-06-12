NB. turn will be a verb with GRID as y, returning GRID.  Therefor:
NB. morpion is move to the power of infinity---convergence.
morpion =: turn ^: _

NB. Detail:

NB. bitwise manipulation definitions for bit masks.
bit_and =: 2b10001 b.
bit_or =: 2b10111 b.

assert 0 0 0 1 -: 0 0 1 1 bit_and 0 1 0 1
assert 0 1 1 1 -: 0 0 1 1 bit_or  0 1 0 1

diagonal =: (<i.2)&|:  NB. verb to extract the major diagonal of a matrix.
assert 0 3 -: diagonal i. 2 2

NB. choose to pack bits into groups of 3.  3 bits can store 0 through 5.
MASKS =: 'MARKED M000 M045 M090 M135'
(MASKS) =: 2b111 * 2b1000 ^ i. # ;: MASKS

bit_to_set =: 2&}.&.#:

MARK =: bit_to_set MARKED

GREEK_CROSS =: MARK * 10 10 $ 'x' = LF -.~ 0 :0
   xxxx
   x  x
   x  x
xxxx  xxxx
x        x
x        x
xxxx  xxxx
   x  x
   x  x
   xxxx
)

NB. frame pads the marked edges of the GRID
frame_top =: 0&,^:(0 ~: +/@:{.)
frame_bot =: frame_top&.:|.
frame_lef=:frame_top&.:|:
frame_rig=: frame_bot&.:|:
frame =: frame_top@:frame_bot@:frame_lef@:frame_rig
assert (-: frame) 1 1 $ 0
assert (3 3 $ _5 {. 1) (-: frame) 1 1 $ 1

odometer =: (4 $. $.)@:($&1) NB. http://www.jsoftware.com/jwiki/Essays/Odometer
index_matrix =: ($ <"1@:odometer)@:$ NB. the computations work with indexes
assert (1 1 ($ <) 0 0) (-: index_matrix) (i. 1 1)

Note 'adverb Line'
 m is the directional bit mask.
 produces the bitmask with a list of index vectors to make a new line.
 use Line:   (1,:1 5) M000 Line ;._3 index_matrix GRID
 Line is a Boolean take of the result.
 Cuts apply Line to each group of 5.
 However I did not figure out how to make this work without a global variable.
)

NB.         the middle 3 are not
NB.         used in this direction       and   4 are already marked
Line =: 1 :'((((0 = m bit_and +/@:}.@:}:) *. (4 = MARKED bit_and +/))@:,@:({&GRID))y){.<(bit_to_set m)(;,)y'

l000 =: (1,:1 5)&(M000 Line;._3)
l045 =: (1,:5 5) M045 Line@:diagonal;._3 |.
l090 =: (1,:5 1)&(M090 Line;._3)
l135 =: (1,:5 5)&(M135 Line@:diagonal;._3)

NB. find all possible moves
compute_marks =: (l135 , l090 , l045 , l000)@:index_matrix  NB. compute_marks GRID

choose_randomly =: {~ ?@:#
apply =: (({~ }.)~ bit_or (MARK bit_or 0&{::@:[))`(}.@:[)`]}
save =: 4 : '(x) =: y'
move =: (apply~ 'CHOICE' save choose_randomly)~

turn =: 3 : 0
 TURN =: >: TURN
 FI =. GRID =: frame y
 MOVES =: _6[\;compute_marks GRID
 GRID =: MOVES move :: ] GRID
 if. TURN e. OUTPUT do.
  smoutput (":TURN),' TURN {'
  smoutput '  choose among'  ; < MOVES
  smoutput '  selected' ; CHOICE
  smoutput '  framed input & ouput' ; FI ; GRID
  smoutput '}'
 end.
 GRID
)

NB. argument y is a vector of TURN numbers to report detailed output.
play =: 3 : 0
 OUTPUT =: y
 NB. save the random state to replay a fantastic game.
 RANDOM_STATE =: '(9!:42 ; 9!:44 ; 9!:0)' ; (9!:42 ; 9!:44 ; 9!:0)''
 if. 0 < # OUTPUT do.
  smoutput 'line angle bit keys for MARK 000 045 090 135: ',":bit_to_set"0 MARKED,M000,M045,M090,M135
  smoutput 'RANDOM_STATE begins as' ; RANDOM_STATE
 end.
 TURN =: _1 NB. count the number of plays.  Convergence requires 1 extra attempt.
 GRID =: morpion GREEK_CROSS           NB. play the game
 TURN
)

NB. example
smoutput play''
