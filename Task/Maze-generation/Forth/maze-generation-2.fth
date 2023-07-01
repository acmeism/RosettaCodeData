#! /usr/bin/gforth
\ Maze Generation

warnings off

require random.fs
require bits.fs

\ command line

: parse-number      s>number? invert throw drop ;
: parse-width       ." width : " next-arg parse-number dup . cr ;
: parse-height      ." height: " next-arg parse-number dup . cr ;
: parse-args        cr parse-width parse-height ;

parse-args constant HEIGHT constant WIDTH

 2 CONSTANT AISLE-WIDTH
 1 CONSTANT AISLE-HEIGHT

WIDTH HEIGHT * bits    CONSTANT VISITED
WIDTH 1- HEIGHT * bits CONSTANT EAST-WALLS
HEIGHT 1- WIDTH * bits CONSTANT SOUTH-WALLS

0 CONSTANT NORTH
1 CONSTANT EAST
2 CONSTANT SOUTH
3 CONSTANT WEST

: visited-ix            ( x y -- u )                WIDTH * + ;
: east-wall-ix          ( x y -- u )                [ WIDTH 1- ] literal * + ;
: south-wall-ix         ( x y -- u )                WIDTH * + ;
: visited!              ( x y -- )                  visited-ix VISITED swap TRUE set-bit ;
: visited?              ( x y -- f )                visited-ix VISITED swap check-bit ;
: east-wall?            ( x y -- f )                east-wall-ix EAST-WALLS swap check-bit ;
: south-wall?           ( x y -- f )                south-wall-ix SOUTH-WALLS swap check-bit ;
: remove-east-wall      ( x y -- )                  east-wall-ix EAST-WALLS swap FALSE set-bit ;
: remove-south-wall     ( x y -- )                  south-wall-ix SOUTH-WALLS swap FALSE set-bit ;

: clear-visited         ( -- )                      VISITED 0 WIDTH 1- HEIGHT 1- visited-ix FALSE set-bits ;
: set-east-walls        ( -- )                      EAST-WALLS 0 WIDTH 2 - HEIGHT 1- east-wall-ix TRUE set-bits ;
: set-south-walls       ( -- )                      SOUTH-WALLS 0 WIDTH 1- HEIGHT 2 - south-wall-ix TRUE set-bits ;
: initial-pos           ( -- x y )                  WIDTH random HEIGHT random ;
: init-state            ( -- -1 x y 0 )             clear-visited set-east-walls set-south-walls -1 initial-pos 2dup visited! 0 ;

: north-valid?          ( x y -- f )                nip 0> ;
: east-valid?           ( x y -- f )                drop [ WIDTH 1- ] literal < ;
: south-valid?          ( x y -- f )                nip [ HEIGHT 1- ] literal < ;
: west-valid?           ( x y -- f )                drop 0> ;
: dir-valid?            ( x y d -- f )              case
                                                        NORTH of north-valid? endof
                                                        EAST  of east-valid?  endof
                                                        SOUTH of south-valid? endof
                                                        WEST  of west-valid?  endof
                                                    endcase ;
: move-north            ( x y -- x' y' )            1- ;
: move-east             ( x y -- x' y' )            swap 1+ swap ;
: move-south            ( x y -- x' y' )            1+ ;
: move-west             ( x y -- x' y' )            swap 1- swap ;
: move                  ( x y d -- x' y' )          case
                                                        NORTH of move-north endof
                                                        EAST  of move-east  endof
                                                        SOUTH of move-south endof
                                                        WEST  of move-west  endof
                                                    endcase ;

: remove-north-wall     ( x y -- )                  1- remove-south-wall ;
: remove-west-wall      ( x y -- )                  swap 1- swap remove-east-wall ;
: remove-wall           ( x y d -- )                case
                                                        NORTH of remove-north-wall endof
                                                        EAST  of remove-east-wall  endof
                                                        SOUTH of remove-south-wall endof
                                                        WEST  of remove-west-wall  endof
                                                    endcase ;

: dir?                  ( m d -- f )                1 swap lshift and 0= ;
: dir!                  ( m d -- m' )               1 swap lshift or ;
: pick-dir              ( m -- m' d )               assert( dup $f <> ) begin 4 random 2dup dir? if tuck dir! swap exit then drop again ;

: update-state          ( x y m d -- x' y' m' )     { x y m d }
                                                    x y d dir-valid? if
                                                        x y m
                                                        x y d move
                                                        2dup visited? if
                                                            2drop
                                                        else
                                                            2dup visited!
                                                            x y d remove-wall
                                                            0
                                                        then
                                                    else
                                                        x y m
                                                    then ;

: step                  ( x y m -- x' y' m' )       dup $f = if
                                                        drop 2drop \ backtracking!
                                                    else
                                                        pick-dir update-state
                                                    then ;

: build-maze            ( -- )                      init-state
                                                    begin
                                                        dup -1 <> while
                                                            step
                                                    repeat drop ;

: corner                ( -- )                      [char] + emit ;
: h-wall                ( -- )                      [char] - emit ;
: v-wall                ( -- )                      [char] | emit ;
: top-bottom.           ( -- )                      cr corner WIDTH 0 ?do AISLE-WIDTH 0 ?do h-wall loop corner loop ;
: empty                 ( -- )                      AISLE-WIDTH 0 ?do space loop ;
: interior-cell         ( x y -- )                  empty east-wall? if v-wall else space then ;
: last-cell             ( -- )                      empty v-wall ;
: row                   ( y -- )                    cr v-wall [ WIDTH 1- ] literal 0 ?do i over interior-cell loop drop last-cell ;
: last-row              ( y -- )                    cr WIDTH 0 ?do corner i over south-wall? if AISLE-WIDTH 0 ?do h-wall loop else empty then loop drop corner ;
: aisle                 ( y -- )                    AISLE-HEIGHT 0 ?do dup row loop dup [ HEIGHT 1- ] literal < if last-row else drop then ;
: maze.                 ( -- )                      top-bottom.
                                                    HEIGHT 0 ?do i aisle loop
                                                    top-bottom. ;
: maze                  ( width height -- )         build-maze maze. ;

maze cr bye
