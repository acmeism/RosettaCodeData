USING: accessors arrays colors combinators
combinators.short-circuit fry grouping io io.styles kernel lexer
literals make math math.matrices math.parser math.vectors random
sequences strings ui ui.commands ui.gadgets.panes
ui.gadgets.status-bar ui.gadgets.worlds ui.gestures
ui.pens.solid ;
IN: rosetta-code.greed

<<
  SYNTAX: RGB: scan-token 2 cut 2 cut [ hex> 255 /f ] tri@ 1
  <rgba> suffix! ;
>>

CONSTANT: cells-width 79
CONSTANT: cells-height 22
CONSTANT: size 24
CONSTANT: bg-color RGB: 000000

CONSTANT: player-format {
    { font-size $ size }
    { foreground RGB: 5990C8 }
    { background RGB: B96646 }
}

CONSTANT: normal-format { { font-size $ size } }

CONSTANT: colors {
    RGB: 40B4A4
    RGB: 40B3B7
    RGB: 40A2B9
    RGB: 408FBC
    RGB: 407CBF
    RGB: 4268C0
    RGB: 4355C2
    RGB: 4845C3
    RGB: 5F46C4
}

CONSTANT: neighbors {
    { -1 -1 } { -1  0 } { -1  1 }
    {  0 -1 }           {  0  1 }
    {  1 -1 } {  1  0 } {  1  1 }
}

TUPLE: greed < pane cells x y score ;

: set-player ( greed elt -- )
    '[ y>> _ swap ] [ x>> 2array ] [ cells>> ] tri set-index ;

: place-player ( greed -- ) 0 set-player ;

: remove-player ( greed -- ) f set-player ;

: make-cells ( -- cells )
    cells-width cells-height * [ 9 random 1 + ] replicate
    cells-width group ;

: write-number ( n/f -- )
    [ >digit 1string normal-format first foreground ]
    [ 1 - colors nth 2array ] bi 2array format ;

: write-cell ( n/f -- )
    {
        { f [ " " normal-format format ] }
        { 0 [ "@" player-format format ] }
        [ write-number ]
    } case ;

: write-cells ( cells -- ) [ [ write-cell ] each nl ] each ;

: update-cells ( greed -- )
    dup cells>> [ write-cells ] curry with-pane ;

: init-greed ( greed -- greed' )
    make-cells >>cells cells-width random >>x cells-height
    random >>y 0 >>score dup place-player dup update-cells dup
    "Score: 0" swap show-status ;

: <greed> ( -- greed )
    f greed new-pane bg-color <solid> >>interior init-greed ;

: ?r,c ( r c matrix -- elt/f ) swapd ?nth ?nth ;

: ?r,cths ( seq matrix -- newseq )
    [ [ first2 ] dip ?r,c ] curry map ;

: (ray) ( start-loc dir length -- seq )
    1 + [ [ [ v+ ] keep over , ] times ] { } make 2nip ;

: ray ( start-loc dir length -- seq/f )
    dup [ (ray) ] [ 2nip ] if ;

: ?r,c-dir ( r c dir matrix -- n )
    [ 2array ] [ v+ first2 ] [ ?r,c ] tri* ;

: move-length ( greed dir -- n )
    [ [ y>> ] [ x>> ] [ ] tri ] dip swap cells>> ?r,c-dir ;

: y,x>loc ( greed -- loc ) [ y>> ] [ x>> ] bi 2array ;

: ray-dir ( greed dir -- seq )
    [ [ y,x>loc ] dip ] [ move-length ] 2bi ray ;

: in-bounds? ( dim loc -- ? )
    { [ nip [ 0 >= ] all? ] [ v- [ 0 > ] all? ] } 2&& ;

: endpoint-in-bounds? ( greed dir -- ? )
    ray-dir dup [
        last ${ cells-height cells-width } swap in-bounds?
    ] when ;

: gapless? ( greed dir -- ? )
    [ ray-dir ] [ drop cells>> ?r,cths ] 2bi [ integer? ] all? ;

: can-move? ( greed dir -- ? )
    { [ endpoint-in-bounds? ] [ gapless? ] } 2&& ;

: can-move-any? ( greed -- ? )
    neighbors [ can-move? ] with map [ t = ] any? ;

: setup-move ( greed dir -- seq ) over remove-player ray-dir ;

: update-score ( greed dir -- greed dir )
    2dup move-length pick swap [ + ] curry change-score dup
    score>> number>string "Score: " prepend swap show-status ;

: (move) ( greed dir -- )
    update-score [ drop f ] [ setup-move dup last ]
    [ drop cells>> swap [ set-indices ] dip ] 2tri first2
    [ >>y ] dip >>x place-player ;

: game-over ( greed -- )
    [
        score>> number>string "Game over! Final score: "
        prepend " Press <space> for new game." append
    ] [ show-status ] bi ;

: ?game-over ( greed -- )
    dup can-move-any? [ drop ] [ game-over ] if ;

: move ( greed dir -- )
    dupd 2dup can-move? [ (move) ] [ 2drop ] if
    [ update-cells ] [ ?game-over ] bi ;

: ?new-game ( greed -- )
    dup can-move-any? [ drop ] [ init-greed drop ] if ;

: e  ( greed -- ) {  0  1 } move ;
: se ( greed -- ) {  1  1 } move ;
: s  ( greed -- ) {  1  0 } move ;
: sw ( greed -- ) {  1 -1 } move ;
: w  ( greed -- ) {  0 -1 } move ;
: nw ( greed -- ) { -1 -1 } move ;
: n  ( greed -- ) { -1  0 } move ;
: ne ( greed -- ) { -1  1 } move ;

greed "gestures" f {
    { T{ key-down { sym "l" } } e  }
    { T{ key-down { sym "n" } } se }
    { T{ key-down { sym "j" } } s  }
    { T{ key-down { sym "b" } } sw }
    { T{ key-down { sym "h" } } w  }
    { T{ key-down { sym "y" } } nw }
    { T{ key-down { sym "k" } } n  }
    { T{ key-down { sym "u" } } ne }
    { T{ key-down { sym " " } } ?new-game }
} define-command-map

: greed-window ( -- )
    [
        <greed> <world-attributes> "Greed" >>title
        open-status-window
    ] with-ui ;

MAIN: greed-window
