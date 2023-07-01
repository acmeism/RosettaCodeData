include random.fs

0 value aiwins
0 value plwins

10 constant inlim
0  constant rock
1  constant paper
2  constant scissors

create rpshistory 0 , 0 , 0 ,
create inversemove 1 , 2 , 0 ,
3 constant historylen

: @a ( n array -- )
    swap cells + @ ;

: sum-history ( -- n )
    0 historylen 0 ?do
	i rpshistory @a 1+ + loop ;

: probable-choice ( -- n ) \ Simple linear search
    sum-history random
    historylen 0 ?do
	i rpshistory @a -
	dup 0< if drop i leave then
    loop inversemove @a ;

: rps-print ( addr u -- )
    cr type ;

: rpslog. ( -- )
    s"       ROCK    PAPER   SCISSORS  AI/W  PL/W" rps-print cr
    3 0 do i cells rpshistory + @ 9 u.r  loop aiwins 7 u.r plwins 6 u.r cr ;

create rpswords ' rock , ' paper , ' scissors , ' quit ,

: update-history! ( n -- )
    cells rpshistory + 1 swap +! ;

: thrown. ( n -- addr u )
    cells rpswords + @ name>string ;

: throws. ( n n -- )
    thrown. s" AI threw:  " 2swap s+ rps-print
    thrown. s" You threw: " 2swap s+ rps-print ;

: print-throws ( n n -- )
    rpslog. throws. ;

: tie. ( n n -- )
    s" Tie. " rps-print ;

: plwin ( n n -- )
    1 +to plwins s" You win. " rps-print ;

: aiwin ( n n -- )
    1 +to aiwins s" AI wins. " rps-print ;

create rpsstates ' tie. , ' plwin , ' aiwin ,

: determine-winner ( n n -- )
    >r abs r> abs - 3 + 3 mod
    cells rpsstates + @  execute ;

: rps-validate ( name -- )  ( Rude way of checking for only valid commands )
    4 0 do i cells rpswords + @ over = swap loop drop or or or ;

: rps-prompt. ( -- )
    s" Enter choice (rock, paper, scissors or quit):   " rps-print ;

: player-choice ( -- n ) recursive
    pad inlim accept pad swap find-name
    dup rps-validate if execute
    else drop rps-prompt. player-choice then ;

: update-log ( n n -- )
    update-history! update-history! ;

: rps ( -- ) recursive
    rps-prompt. player-choice probable-choice
    2dup update-log 2dup print-throws
    determine-winner rps ;
