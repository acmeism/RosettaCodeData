USING: accessors images images.testing images.viewer kernel
literals math math.constants math.functions sequences ;
IN: rosetta-code.koch-curve

CONSTANT: order 17
CONSTANT: theta 1.047197551196598      ! 60 degrees in radians
CONSTANT: move-distance 0.25
CONSTANT: dim { 600 400 }
CONSTANT: offset-x 500
CONSTANT: offset-y 300

: <koch-image> ( -- image )
    <rgb-image> dim >>dim
    dim product 3 * [ 255 ] B{ } replicate-as >>bitmap ;

: thue-morse ( n -- seq )
    { 0 } swap [ [ ] [ [ 1 bitxor ] map ] bi append ] times ;

TUPLE: turtle
    { heading initial: 0 } { x initial: 0 } { y initial: 0 } ;

: turn ( turtle -- turtle' )
    [ theta + 2pi mod ] change-heading ;

: move ( turtle -- turtle' )
    dup heading>> [ cos move-distance * + ] curry change-x
    dup heading>> [ sin move-distance * + ] curry change-y ;

: step ( turtle elt -- turtle' )
    [ move ] [ drop turn ] if-zero ;

: setup-pixel ( turtle -- pixel x y )
    { 0 0 0 } swap [ x>> ] [ y>> ] bi
    [ >integer ] bi@ [ offset-x + ] [ offset-y + ] bi* ;

: koch-curve ( -- )
    <koch-image> turtle new over order thue-morse [
        [ dup setup-pixel ] [ set-pixel-at ] [ step drop ] tri*
    ] 2with each image-window ;

MAIN: koch-curve
