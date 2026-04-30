\ Hunt the Wumpus - FORTH - v 1.00

: wumpus-version ( -- )
    ." Version 1.00 - FORTH "
  ;

[DEFINED] UTIME [IF] ( -- Dusec )
   : MS@ UTIME DROP ;  \ gforth
[ELSE]
[DEFINED] counter [IF]
   : MS@ counter ;     \ SwiftForth
[THEN] [THEN]

include random.fs \ defines random ( n -- 0..n-1 )

\ Initialize random seed from a
\ value that changes with time
MS@ SEED !

\
\ The cave: 20 rooms, each connected to 3 others,
\ as a dodecahedron
\
20 CONSTANT COUNT-ROOMS
 3 CONSTANT COUNT-NEIGHBORS
CREATE CAVE \ adjacency list
   5 C,  8 C,  2 C, \ ROOM 1
   1 C, 10 C,  3 C, \ ROOM 2
   2 C, 12 C,  4 C, \ ROOM 3
   3 C, 14 C,  5 C, \ ROOM 4
   4 C,  6 C,  1 C, \ ROOM 5
  15 C,  5 C,  7 C, \ ROOM 6
   6 C, 17 C,  8 C, \ ROOM 7
   7 C,  1 C,  9 C, \ ROOM 8
   8 C, 18 C, 10 C, \ ROOM 9
   9 C,  2 C, 11 C, \ ROOM 10
  10 C, 19 C, 12 C, \ ROOM 11
  11 C,  3 C, 13 C, \ ROOM 12
  12 C, 20 C, 14 C, \ ROOM 13
  13 C,  4 C, 15 C, \ ROOM 14
  14 C, 16 C,  6 C, \ ROOM 15
  20 C, 15 C, 17 C, \ ROOM 16
  16 C,  7 C, 18 C, \ ROOM 17
  17 C,  9 C, 19 C, \ ROOM 18
  18 C, 11 C, 20 C, \ ROOM 19
  19 C, 13 C, 16 C, \ ROOM 20

\ Game state
CREATE HUNTER 1 CHARS ALLOT \ Player location
CREATE WUMPUS 1 CHARS ALLOT \ Wumpus location
CREATE PITS   2 CHARS ALLOT \ Rooms with pits
CREATE BATS   2 CHARS ALLOT \ Rooms with bats

CREATE ARROWS 1 CHARS ALLOT \ Crooked arrows left
CREATE PLAYER 1 CHARS ALLOT \ IN-PLAY, WON, LOST

\ Keep track of whether bats snatched the Hunter
\ TRUE if bats moved player
CREATE BATS-MOVED-HUNTER 1 CELLS ALLOT

\ Arrow path
CREATE ARROW-PATH-LENGTH 1 CHARS ALLOT
CREATE ARROW-PATH-ROOMS  5 CHARS ALLOT

\ Initial room assignments in order:
\ Hunter, Wumpus, pits, bats
CREATE INITIAL-ROOMS 6 CHARS ALLOT

\ Scratch area for generating a random shuffle
\ of the 20 room numbers
CREATE ROOM-NUMBERS COUNT-ROOMS CHARS ALLOT

\ Player states
0 CONSTANT IN-PLAY
1 CONSTANT WON
2 CONSTANT LOST

\ Quit, or play again with new or same initial state
0 CONSTANT QUIT-GAME
1 CONSTANT SAME-ROOMS
2 CONSTANT NEW-ROOMS

\ A pointer to a prompt string
CREATE PROMPT-STRING 2 CELLS ALLOT

\ An 8-character buffer for prompt answers
8 CONSTANT MAX-ANSWER-LENGTH
CREATE PROMPT-ANSWER MAX-ANSWER-LENGTH CHARS ALLOT

\ Responses to a yes-no question
CHAR y CONSTANT YES
CHAR n CONSTANT NO

\ Responses to a command prompt
CHAR w CONSTANT WHERE-AM-I?
CHAR m CONSTANT MOVE-ME
CHAR s CONSTANT SHOOT
\ - undocumented -
CHAR g CONSTANT GAME-STATE \ show the game state
CHAR c CONSTANT CAVE-ROOMS \ show all the cave rooms

ALIGN  \ Align to next slot boundary

\
\ The Cave
\   room-number in 1..20
\ WARNING: These cave referencing words
\ don't validate room numbers!!!
\

\ Determine if a room number is in the cave
: ?cave-room-number-valid ( room-number -- flag )
    DUP 0 < SWAP COUNT-ROOMS > OR INVERT
  ;

\ Get a pointer to a room
: cave-room-address ( room-number -- room-address )
    1- COUNT-NEIGHBORS * CHARS CAVE +
  ;

\ Get the room number of a neighbor
: cave-room-neighbor ( index room-number -- room-number )
    cave-room-address SWAP CHARS + C@
  ;

\ Get a list of a room's neighbors
: cave-room-neighbors ( room-number -- n_1 n_2 n_3 )
    DUP cave-room-address           C@ SWAP
    DUP cave-room-address   CHAR+   C@ SWAP
        cave-room-address 2 CHARS + C@
  ;

\ Determine if a room is a neighbor
: ?cave-room-reachable ( to from -- flag )
    cave-room-neighbors FALSE
    4 PICK 4 PICK = OR
    4 PICK 3 PICK = OR
    4 PICK 2 PICK = OR
    SWAP DROP SWAP DROP SWAP DROP SWAP DROP
  ;

\ Does this room have the Hunter in it?
: ?cave-room-has-hunter ( room-number -- flag )
    HUNTER C@ =
  ;

\ Does this room have the Wumpus in it?
: ?cave-room-has-wumpus ( room-number -- flag )
    WUMPUS C@ =
  ;

\ Does this room have a bottomless pit in it?
: ?cave-room-has-pit ( room-number -- flag )
    DUP PITS C@ = SWAP PITS CHAR+ C@ = OR
  ;

\ Does this room have super bats in it?
: ?cave-room-has-bats ( room-number -- flag )
    DUP BATS C@ = SWAP BATS CHAR+ C@ = OR
  ;

\
\ Room number selection - for initial room assignments
\
\ This is a variant of the
\ Fisher-Yates shuffle (a.k.a. the Knuth shuffle),
\ starting from the beginning of the rooms list,
\ and selecting only as many rooms as needed.
\

\ Fill room numbers with the sequence 1..20
: reset-room-numbers ( -- )
    COUNT-ROOMS 0 DO I CHARS ROOM-NUMBERS + I 1+ SWAP C! LOOP
  ;

\ Display the room numbers
: show-room-numbers ( -- )
    COUNT-ROOMS 0 DO I CHARS ROOM-NUMBERS + C@ . LOOP
  ;

\ Choose a room in i..19 (yes, it could be i)
: choose-room-in-tail ( i -- r )
    DUP COUNT-ROOMS 1- SWAP -  \ max-index-within-tail
    1+ random +                \ r
  ;

\ Swap ith (i in 0..19) room with a room in i..19
: swap-random-in-tail ( i -- )
    DUP ROOM-NUMBERS CHARS + C@ SWAP   \ -- Ni i
    DUP choose-room-in-tail TUCK       \ -- Ni r i r
    ROOM-NUMBERS CHARS + C@ SWAP       \ -- Ni r Nr i
    ROOM-NUMBERS CHARS + C!            \ -- Ni r
    ROOM-NUMBERS CHARS + C!
  ;

\ Select n <= 20 rooms at random
: select-random-rooms ( n -- random-rooms )
    DUP COUNT-ROOMS > IF
      CR . ABORT" Can't select more than 20 rooms "
    THEN
    reset-room-numbers
    0 DO
      I swap-random-in-tail
      \ CR I . ." : " show-room-numbers
    LOOP
  ;

\ Create and save a new room configuration
: create-new-room-assignments ( -- )
    6 select-random-rooms
    ROOM-NUMBERS INITIAL-ROOMS 6 CMOVE
  ;

\
\ Player dialogue
\

\ Show the game state
: show-game-state ( -- )
    CR ." HUNTER: " HUNTER C@ .
    CR ." WUMPUS: " WUMPUS C@ .
    CR ." PITS:   " PITS   C@ . PITS CHAR+ C@ .
    CR ." BATS:   " BATS   C@ . BATS CHAR+ C@ .
    CR ." ARROWS: " ARROWS C@ .
    CR ." PLAYER: " PLAYER C@
    CASE
      LOST    OF ." LOST "    ENDOF
      IN-PLAY OF ." IN-PLAY " ENDOF
      WON     OF ." WON "     ENDOF
      DUP CR . ." unexpected PLAYER state "
    ENDCASE
  ;

\ List the neighboring rooms
: list-neighbors ( room-number -- )
    cave-room-neighbors
    . . .
  ;

\ Show a list of all the cave's rooms
: show-cave-rooms ( -- )
    COUNT-ROOMS 0 DO
      I 1+ DUP CR . ." : " list-neighbors
    LOOP
  ;

\ Accept an answer from the player
: input-answer ( max-length -- length ; chars in PROMPT-ANSWER )
    MAX-ANSWER-LENGTH MIN \ Limit input to buffer length
    BEGIN
      CR ." > "
      DUP PROMPT-ANSWER SWAP ACCEPT
      DUP 0 > DUP INVERT IF
        CR ." Huh? "
        SWAP DROP \ Forget zero length
      THEN
    UNTIL \ Try again if no characters entered
    SWAP DROP \ Forget max input length
  ;

\ Input one lowercase ASCII character from the player
: input-ascii-lowercase ( -- answer )
    1 input-answer DROP \ Forget length
    \ Convert ASCII alpha to lowercase; others don't care
    PROMPT-ANSWER C@ 32 OR PROMPT-ANSWER C!
    PROMPT-ANSWER C@
  ;

\ Accept a numeric answer from the player
: input-number ( -- number )
    BEGIN
      2 input-answer PROMPT-ANSWER SWAP \ -- answer-address length
      \ try to convert the answer into a number
      0 0 2SWAP >NUMBER \ -- n 0 remnant-address remnant-length
      0= DUP INVERT IF  \ -- n 0 remnant-address flag
        CR ." That is not a number. "
        2SWAP 2DROP \ Forget invalid answer
        SWAP DROP   \ Forget remnant-address, leaving FALSE
      ELSE \ Entire answer was converted to a number
        SWAP DROP   \ Forget remnant-address
        SWAP DROP   \ Forget high-order zero of number in 0..99
      THEN
    UNTIL \ Try again if answer was invalid
  ;

\ Ask a yes-no question, don't accept anything else
: prompt-yes-no ( question -- YES | NO )
    PROMPT-STRING 2!
    BEGIN
      CR PROMPT-STRING 2@ TYPE ." (y|n)? "
      input-ascii-lowercase
      DUP YES = OVER NO = OR
      DUP INVERT IF
        CR ." Huh? "
        SWAP DROP \ Forget invalid answer
      THEN
    UNTIL \ Try again if answer was invalid
  ;

\ Show the stored crooked arrow path
: show-arrow-path ( -- )
    CR ." ARROW PATH - "
    ARROW-PATH-LENGTH C@ DUP . ." : " 0 DO
      ARROW-PATH-ROOMS I CHARS + C@ .
    LOOP
  ;

\ Prompt for path length when shooting a crooked arrow
: prompt-arrow-path-length ( -- 1..5 )
    BEGIN
      CR ." How many rooms should the arrow traverse (1..5)? "
      input-number
      DUP 1 < OVER 5 > OR
      DUP IF
        CR ." Huh? "
        SWAP DROP \ Forget invalid answer
      THEN
      INVERT
    UNTIL \ Try again if room count was invalid
  ;

\ Get room number arrow can't go back to
: arrow-path-backtrack-room ( index -- invalid-room )
    \ The arrow is not so crooked that it
    \ can go out the tunnel it came in through.
    DUP 1 > IF
      \ Path has more than one room already;
      \ the arrow can't go back to the room
      \ before the last one entered.
      2 - CHARS ARROW-PATH-ROOMS + C@
    ELSE
      1 = IF
        \ Path has exactly one room so far; the arrow
        \ can't go back to the room the Hunter is in.
        HUNTER C@
      ELSE
        \ This is to be the first room in the path;
        \ the arrow can be sent anywhere,
        \ including the room the Hunter is in.
        0  \ Zero won't match any room.
      THEN
    THEN
  ;

\ Prompt for the next room in the arrow's path
: prompt-arrow-path-room ( index -- room )
    BEGIN
      CR ." Enter room " DUP 1+ .
      input-number \ -- index room
      OVER arrow-path-backtrack-room \ -- index room invalid-room
      OVER = DUP IF \ -- index room flag
        CR ." Huh, arrows aren't that crooked! "
        SWAP DROP \ Forget chosen room
      ELSE
        ROT DROP  \ Forget the index
      THEN \ -- index TRUE | room FALSE
      INVERT
    UNTIL \ Try again if room was invalid
  ;

\ Prompt for the arrow's path when shooting a crooked arrow
: prompt-arrow-path ( -- ; sets arrow path length and rooms )
    prompt-arrow-path-length
    DUP ARROW-PATH-LENGTH C! 0 DO
      I prompt-arrow-path-room
      ARROW-PATH-ROOMS I CHARS + C!
    LOOP
  ;

\ Prompt for a command
: prompt-command ( -- MOVE-ME | SHOOT | WHERE-AM-I? )
    BEGIN
      CR ." What do you want to do "
         ." (m=move, s=shoot, w=where am I?)? "
      input-ascii-lowercase
      DUP MOVE-ME = OVER SHOOT        = OR
                    OVER WHERE-AM-I?  = OR
                    \ - undocumented -
                    OVER GAME-STATE   = OR
                    OVER CAVE-ROOMS   = OR
      DUP INVERT IF
        CR ." Huh? "
        SWAP DROP \ Forget invalid answer
      THEN
    UNTIL \ Try again if command was invalid
  ;

\ Prompt to play again, with same or new room assignments
: prompt-play-again ( -- QUIT-GAME | SAME-ROOMS | NEW-ROOMS )
    s" Play again " prompt-yes-no
    YES = IF
      CR ." OK, play again ... "
      s" Same rooms " prompt-yes-no
      YES = IF
        CR ." OK, you, the Wumpus, pits, and bats in the same rooms. "
        SAME-ROOMS
      ELSE
        CR ." OK, you, the Wumpus, pits, and bats in new rooms (probably). "
        NEW-ROOMS
      THEN
    ELSE
      CR ." Bye "
      QUIT-GAME
    THEN
  ;

\ Display congratulations or condolences
: show-result ( WON | LOST -- )
    DUP WON = IF
      CR ." Congratulations! You got the Wumpus! But next time, hee, hee, hee!"
      DROP
    ELSE
      DUP LOST = IF
        CR ." Condolences, maybe better luck next time."
        DROP
      ELSE
        CR . ." unknown game result."
      THEN
    THEN
  ;

\ Get a new room for the player
: prompt-new-hunter-room ( -- room )
    BEGIN
      CR ." Where do you want to go? "
      input-number
      DUP  ?cave-room-has-hunter IF
        CR ." You are already in room " . ." ... "
        DROP  \ Forget room Hunter already in
        FALSE \ answer not valid, try again
      ELSE
        DUP HUNTER C@ ?cave-room-reachable
        DUP INVERT IF
          CR ." Can't get there from here. "
          SWAP DROP  \ Forget unreachable room
        THEN
      THEN
    UNTIL \ Try again if room was invalid
  ;

\ Display instructions
: show-instructions ( -- )
    CR ." ---- INSTRUCTIONS ---- "
    CR
    CR ." Welcome to Hunt the Wumpus! You are a hunter, looking to bag a Wumpus. "
    CR
    CR ." The Wumpus lives in a cave of twenty rooms, each connected by "
    CR ." tunnels to three other rooms, as in a dodecahedron. "
    CR
    CR ." There are HAZARDS!! "
    CR
    CR ." The Wumpus - One room has the Wumpus in it. If the Wumpus "
    CR ." finds you in the room with it, it will eat you and you lose. "
    CR
    CR ." Bottomless Pits - Two rooms have bottomless pits in them. "
    CR ." If you go there, you fall into the pit and lose. "
    CR
    CR ." Super Bats - Two other rooms have super bats in them. "
    CR ." If you go there, a bat grabs you and takes you to another "
    CR ." room, at random. This might be troublesome. "
    CR
    CR ." As you are hunting, you will be able to sense something of "
    CR ." the hazards, when you are in a room adjacent to one. "
    CR
    CR ." - You can smell the Wumpus, when it is nearby. "
    CR ." - You can feel a breeze, when there is a pit nearby "
    CR ." - You can hear a rustling sound, when there are bats nearby. "
    CR
    CR ." The Wumpus is not bothered by the hazards. It has sucker "
    CR ." feet, so can cling to the walls of a pit, and is too heavy "
    CR ." for the super bats to lift. Usually, it is asleep. "
    CR
    CR ." Two things wake up the Wumpus: you entering its room, or "
    CR ." you shooting an arrow (anywhere in the cave!). When it "
    CR ." wakes, it moves into an adjacent room (P=3/4) or stays "
    CR ." where it is (P=1/4). After that, if it is where you are "
    CR ." it eats you and you lose. "
    CR
    CR ." The computer starts you in a randomly chosen room. "
    CR ." Each turn you can move to an adjacent room or shoot an arrow. "
    CR
    CR ." You are furnished with 5 crooked arrows, which you can program "
    CR ." to go into 1 to 5 rooms. Starting from the room you are in, "
    CR ." the arrow will go from room to room provided there is a tunnel "
    CR ." from where it is to the next room on its list. If there is no "
    CR ." tunnel, the arrow bounces on the walls of the cave and moves into "
    CR ." an adjacent room at random, possibly the one you are in. "
    CR
    CR ." - If the arrow hits the Wumpus, you win. "
    CR ." - If the arrow hits you, you lose. "
    CR ." - If you run out of arrows, you lose. "
    CR
    CR ." When the game is over, you can start a new game. "
    CR ." You can choose to start over with the same configuration "
    CR ." as the game you just finished, that is: with you, the Wumpus, "
    CR ." the pits, and the bats where they started in the game you "
    CR ." just finished; or you can start fresh, with everything in "
    CR ." new places (well, probably). In any case, you get a fresh "
    CR ." supply of five arrows. "
    CR
    CR ." Good luck! "
  ;

\ Display instructions if wanted
: show-instructions-if-wanted ( -- )
    s" Show instructions " prompt-yes-no
    YES = IF
      show-instructions
    THEN
  ;

\ Display a greeting
: show-greeting ( -- )
    CR ."  ----  ----  Hunt the Wumpus  ----  ----  "
    CR ."  - " wumpus-version
    CR ."  ----  ----  ---------------  ----  ----  "
  ;

\
\ Game play
\

\ List any hazards in a room
: hazards-in-room ( room-number -- )
    DUP ?cave-room-has-wumpus IF
     CR ." I smell a Wumpus!"
    THEN
    DUP ?cave-room-has-pit IF
     CR ." I feel a draft!"
    THEN
    DUP ?cave-room-has-bats IF
     CR ." I hear a rustling sound!"
    THEN
    DROP \ Forget room number
  ;

\ Warn of any hazards in the neighboring rooms
: warn-of-hazards ( room-number -- )
    cave-room-neighbors
    hazards-in-room
    hazards-in-room
    hazards-in-room
  ;

\ Describe the Hunter's location
: describe-hunter-location ( -- )
    HUNTER C@
    CR ." You are in room " DUP .
    CR ." Tunnels lead to rooms " DUP list-neighbors
    warn-of-hazards
  ;

\ The Wumpus eats the Hunter if in the same room
: wumpus-ate-hunter? ( -- ; may set player state to LOST )
    HUNTER C@ ?cave-room-has-wumpus IF
      CR ." Aaaaggghhh! The Wumpus got you! You lose! "
      LOST PLAYER C!
    ELSE
      CR ." Phew! The Wumpus didn't get you. "
    THEN
  ;

\ Move the Wumpus - did it get the Hunter?
: move-wumpus ( -- ; may set player state to LOST )
    CR ." Uh oh! You disturbed the Wumpus! "
    4 random DUP 3 < IF
      WUMPUS C@ cave-room-neighbor WUMPUS C!
    ELSE
      DROP \ Forget index indicating Wumpus didn't move
    THEN
    wumpus-ate-hunter? \ may set player state to LOST
  ;

\ Did the crooked arrow hit the Wumpus?
: arrow-hit-wumpus? ( room -- flag ; may set player state to WON )
    ?cave-room-has-wumpus DUP IF
      CR ." Aha! You got the Wumpus! "
      WON PLAYER C!
    THEN
  ;

\ Did the crooked arrow hit the Hunter?
: arrow-hit-hunter? ( room -- flag ; may set player state to LOST )
     ?cave-room-has-hunter DUP IF
      CR ." Ouch! Arrow got you! You lose!"
      LOST PLAYER C!
    THEN
  ;

\ Did the Hunter run out of crooked arrows?
: arrows-all-gone? ( -- ; may set player state to LOST )
    ARROWS C@ 1- DUP ARROWS C! 0 = IF
      CR ." You're out of arrows, you lose! "
      LOST PLAYER C!
    THEN
  ;

\ Fly a crooked arrow
: fly-arrow ( -- ; may set player state to WON or LOST )
    HUNTER C@ \ arrow starts where player is
    DUP CR .
    ARROW-PATH-LENGTH C@ 0 DO
      ." --> "
      ARROW-PATH-ROOMS I CHARS + C@ \ Rf -- Rf Rt
      2DUP SWAP ?cave-room-reachable IF
        SWAP DROP \ Rf Rt -- Rt ; Arrow now in next room in path
      ELSE
        DROP \ Rf Rt -- Rf ; Forget the unreachable room
        CR ." Uh oh! You hit the cave wall, arrow gone astray! "
        \ Arrow enters one of the adjoining rooms
        cave-room-address 3 random CHARS + C@ \ Rf -- Rt
      THEN
      DUP .
      \ OK, what happens when the arrow reaches this room?
      DUP arrow-hit-hunter? OVER arrow-hit-wumpus? OR IF
        LEAVE \ That's the end of the arrow's flight
      THEN
    LOOP
    DROP \ Forget the last room the arrow went into
  ;

\ Shoot a crooked arrow
: shoot-arrow ( -- )
    prompt-arrow-path
    show-arrow-path
    fly-arrow \ may set player state to WON or LOST
    PLAYER C@ IN-PLAY = IF
      \ The arrow didn't hit anything
      CR ." You missed! "
      \ Shooting an arrow always disturbs the Wumpus
      move-wumpus      \ may set player state to LOST
      arrows-all-gone? \ may set player state to LOST
    THEN
  ;

\ Hunter went into a room with super bats?
: entered-room-with-bats? ( -- flag )
    HUNTER C@ ?cave-room-has-bats DUP IF
      CR ." Oh oh oh! A bat's got you! Oh ohhh ... "
      COUNT-ROOMS random 1+ DUP HUNTER C!
      CR ." You are now in room " .
    THEN
    \ Return TRUE if a super bat moved the Hunter
  ;

\ Hunter went into a room with a bottomless pit?
: entered-room-with-pit? ( -- ; may set player state to LOST )
    HUNTER C@ ?cave-room-has-pit IF
      CR ." Aaaaggghhh! You fell in a pit! You lose! "
      LOST PLAYER C!
    THEN
  ;

\ Hunter went into a room with the Wumpus?
: entered-room-with-wumpus? ( -- ; may set player state to LOST )
    HUNTER C@ ?cave-room-has-wumpus IF
      move-wumpus \ may set player state to LOST
    THEN
  ;

\ Move the Hunter to a new room
: move-hunter ( -- ; may set player state to LOST )
    prompt-new-hunter-room HUNTER C!
    BEGIN
      FALSE BATS-MOVED-HUNTER !
      entered-room-with-wumpus? \ may set player state to LOST
      PLAYER C@ IN-PLAY = IF
        entered-room-with-pit?  \ may set player state to LOST
        PLAYER C@ IN-PLAY = IF
          entered-room-with-bats? BATS-MOVED-HUNTER !
        THEN
      THEN
      BATS-MOVED-HUNTER @ INVERT
    UNTIL \ repeat if the bats moved the Hunter
    PLAYER C@ IN-PLAY = IF
      \ Nothing too bad happened, let's take a moment
      \ to take in our surroundings
      describe-hunter-location
    THEN
  ;

\ Play the game until won or lost
: play ( -- WON | LOST )
    BEGIN PLAYER C@ IN-PLAY = WHILE
      prompt-command  \ -- MOVE-ME | SHOOT | WHERE-AM-I?
      CASE
        MOVE-ME      OF move-hunter              ENDOF
        SHOOT        OF shoot-arrow              ENDOF
        WHERE-AM-I?  OF describe-hunter-location ENDOF
        \ - undocumented -
        GAME-STATE   OF show-game-state          ENDOF
        CAVE-ROOMS   OF show-cave-rooms          ENDOF
        CR . ." unexpected command."
      ENDCASE
    REPEAT
    PLAYER C@
  ;

\ Set the room configuration to the saved one
: set-rooms-to-initial-assignments ( -- )
    INITIAL-ROOMS           C@ HUNTER     C!
    INITIAL-ROOMS   CHAR+   C@ WUMPUS     C!
    INITIAL-ROOMS 2 CHARS + C@ PITS       C!
    INITIAL-ROOMS 3 CHARS + C@ PITS CHAR+ C!
    INITIAL-ROOMS 4 CHARS + C@ BATS       C!
    INITIAL-ROOMS 5 CHARS + C@ BATS CHAR+ C!
  ;

\ Reset the state for a new game
: new-game ( SAME-ROOMS | NEW-ROOMS -- )
    NEW-ROOMS = IF
      create-new-room-assignments
    THEN
    set-rooms-to-initial-assignments
    5 ARROWS C!
    IN-PLAY PLAYER C!
  ;

\ Greet the player, play, then prompt for a new game
: Hunt-the-Wumpus ( -- )
    show-greeting
    show-instructions-if-wanted
    NEW-ROOMS
    BEGIN
      new-game                  \ SAME-ROOMS | NEW-ROOMS --
      describe-hunter-location  \ --
      play                      \ -- WON | LOST
      show-result               \ WON | LOST --
      prompt-play-again         \ -- QUIT-GAME | SAME-ROOMS | NEW-ROOMS
      DUP QUIT-GAME =
    UNTIL
    DROP \ Forget the QUIT-GAME indicator
  ;
