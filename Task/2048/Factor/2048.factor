USE: accessors
FROM: arrays => <array> array ;
FROM: assocs => assoc-filter keys zip ;
FROM: combinators => case cleave cond ;
FROM: combinators.short-circuit => 1|| 1&& 2&& ;
FROM: continuations => cleanup ;
FROM: formatting => printf sprintf ;
FROM: fry => '[ _ ;
FROM: grouping => all-equal? clump group ;
FROM: io => bl flush nl readln write ;
FROM: kernel => = 2bi 2dup 2drop and bi bi* bi@ boa boolean clone equal? dip drop dup if if* keep loop nip not over swap throw tri unless when with xor ;
FROM: math => integer times * + > >= ;
FROM: math.functions => ^ ;
FROM: math.parser => hex> ;
FROM: math.order => +lt+ +gt+ +eq+ ;
FROM: random => random sample ;
FROM: sequences => <iota> <repetition> any? all? append concat each first flip head if-empty interleave length map pop push reduce reverse second set-nth tail ;
FROM: sorting => sort ;
FROM: vectors => <vector> ;
IN: 2048-game


ERROR: invalid-board ;

SYMBOL: left
SYMBOL: right
SYMBOL: up
SYMBOL: down

TUPLE: tile
{ level integer }
;

TUPLE: board
{ width integer }
{ height integer }
{ tiles array }
;

M: tile equal?
    {
        [ and ] ! test for f
        [ [ level>> ] bi@ = ]
    }
    2&&
;

: valid-board? ( w h -- ? )
    * 0 > ! board with 0 tiles does not have a meaningful representation
;

: <board> ( w h -- board )
    [ valid-board? [ invalid-board throw ] unless ]
    [ 2dup * f <array> board boa ] 2bi
;

: <tile> ( n -- tile )
    tile boa
;

! 1 in 10 tile starts as 4
: new-tile ( -- tile )
    10 random 0 = [ 2 ] [ 1 ] if
    <tile>
;

<PRIVATE

: space-left? ( board -- ? )
    tiles>> [ f = ] any?
;

: rows>> ( board -- seq )
    dup tiles>>
    [ drop { } ] [ swap width>> group ] if-empty
;

: rows<< ( seq board -- )
    [ concat ] dip tiles<<
;

: columns>> ( board -- seq )
    rows>> flip
;

: columns<< ( seq board -- )
    [ flip concat ] dip tiles<<
;

: change-rows ( board quote -- board )
    over [ rows>> swap call( seq -- seq ) ] [ rows<< ] bi
; inline

: change-columns ( board quote -- board )
    over [ columns>> swap call( seq -- seq ) ] [ columns<< ] bi
; inline

: can-move-left? ( seq -- ? )
    {
        ! one element seq cannot move
        [ length 1 = not ]
        ! empty seq cannot move
        [ [ f = ] all? not ]
        [ 2 clump
            [
                {
                    ! test for identical adjescent tiles
                    [ [ first ] [ second ] bi [ and ] [ = ] 2bi and ]
                    ! test for empty space on the left and tile on the right
                    [ [ first ] [ second ] bi [ xor ] [ drop f = ] 2bi and ]
                } 1||
            ] any?
        ]
    } 1&&
;

: can-move-direction? ( board direction -- ? )
    {
        { left  [ rows>>    [         can-move-left? ] any? ] }
        { right [ rows>>    [ reverse can-move-left? ] any? ] }
        { up    [ columns>> [         can-move-left? ] any? ] }
        { down  [ columns>> [ reverse can-move-left? ] any? ] }
    } case
;

: can-move-any? ( board -- ? )
    { left right up down } [ can-move-direction? ] with any?
;

: empty-indices ( seq -- seq )
    [ length <iota> ] keep zip
    [ nip f = ] assoc-filter keys
;

: pick-random ( seq -- elem )
    1 sample first
;

! create a new tile on an empty space
: add-tile ( board -- )
    [ new-tile swap [ empty-indices pick-random ] keep [ set-nth ] keep ] change-tiles drop
;

! combines equal tiles justified right or does nothing
: combine-tiles ( tile1 tile2 -- tile3 tile4 )
    2dup { [ and ] [ = ] } 2&&
    [ drop [ 1 + ] change-level f swap ] when
;

: justify-left ( seq -- seq )
    [
        {
            { [ dup  f = ] [ 2drop +lt+ ] }
            { [ over f = ] [ 2drop +gt+ ] }
            [ 2drop +eq+ ]
        } cond
    ] sort
;

: collapse ( seq -- seq )
    justify-left

    ! combine adjescent
    dup length <vector>
    [ over
        [ swap [ push ] keep ]
        [
            {
                [ pop combine-tiles ]
                [ push ]
                [ push ]
            } cleave
        ] if-empty
    ] reduce

    ! fill in the gaps after combination
    justify-left
;

! draws an object
GENERIC: draw ( obj -- )

PRIVATE>

! a single tile is higher than 2048 (level 10)
: won? ( board -- ? )
    tiles>> [ dup [ level>> 11 >= ] when ] any?
;

! if there is no space left and no neightboring tiles are the same, end the board
: lost? ( board -- ? )
    {
        [ space-left? ]
        [ won? ]
        [ can-move-any? ]
    } 1|| not
;

: serialize ( board -- str )
    [ width>> ]
    [ height>> ]
    [ tiles>>
        [ dup f = [ drop 0 ] [ level>> ] if "%02x" sprintf ] map concat
    ] tri
    "%02x%02x%s" sprintf
;

: deserialize ( str -- board )
    [ 2 head hex> ] [ 2 tail ] bi
    [ 2 head hex> ] [ 2 tail ] bi
    2 group [ hex> dup 0 = [ drop f ] [ tile boa ] if ] map
    board boa
;

: move ( board direction -- )
    {
        { left  [ [ [         collapse         ] map ] change-rows    ] }
        { right [ [ [ reverse collapse reverse ] map ] change-rows    ] }
        { up    [ [ [         collapse         ] map ] change-columns ] }
        { down  [ [ [ reverse collapse reverse ] map ] change-columns ] }
    } case drop
;


: get-input ( -- line )
    readln
;

: parse-input ( line -- direction/f )
    {
        { "a" [ left  ] }
        { "d" [ right ] }
        { "w" [ up    ] }
        { "s" [ down  ] }
        { "q" [ f ] }
        [ "Wrong input: %s\n" printf flush
          get-input parse-input ]
    } case
;

<PRIVATE

: init ( board -- )
    '[ _ add-tile ] 2 swap times
;

M: tile draw ( tile -- )
    level>> 2 swap ^ "% 4d" printf
;

M: boolean draw ( _ -- )
    drop 4 [ bl ] times
;

: horizontal-line ( board -- )
    width>>
    " " write
    "+------" <repetition> concat
    write "+ " write nl
;

: separator ( -- )
    " | " write
;

M: board draw ( board -- )
    [ horizontal-line ] keep
    [ rows>> ]
    [
       '[ _ horizontal-line ]
        [   separator
            [ separator ] [ draw ] interleave
            separator nl
        ] interleave
    ]
    [ horizontal-line ]
    tri
    flush
;

: update ( board -- f )
    {
        [
            get-input parse-input [
                {
                    [ can-move-direction? ]
                    [ over [ move ] [ add-tile ] bi* t ]
                } 2&& drop t
            ] [ drop f ] if*
        ]
        [ can-move-any? ]
    } 1&&
;

: exit ( board -- )
    {
        { [ dup lost? ] [ "You lost! Better luck next time." write nl ] }
        { [ dup won?  ] [ "You won! Congratulations!" write nl ] }
        [ "Bye!" write nl ]
    } cond drop
;

PRIVATE>

: start-2048 ( -- )
    4 4 <board>
    [
        ! Initialization
        [ init ]
        [ draw ]
        ! Event loop
        [ [ dup [ update ] [ draw ] bi ] loop ] tri
    ]
    ! Cleanup
    [ exit ]
    [ ]
    cleanup
;

MAIN: start-2048
