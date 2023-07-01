USING: accessors arrays calendar colors combinators
combinators.short-circuit fonts fry generalizations kernel
literals locals math math.ranges math.vectors namespaces opengl
random sequences timers ui ui.commands ui.gadgets
ui.gadgets.worlds ui.gestures ui.pens.solid ui.render ui.text ;
IN: rosetta-code.galton-box-animation

CONSTANT: pegs $[ 20 300 40 <range> ]
CONSTANT: speed 90
CONSTANT: balls 140
CONSTANT: peg-color  T{ rgba f 0.60 0.4 0.60 1.0 }
CONSTANT: ball-color T{ rgba f 0.80 1.0 0.20 1.0 }
CONSTANT: slot-color T{ rgba f 0.00 0.2 0.40 1.0 }
CONSTANT: bg-color   T{ rgba f 0.02 0.0 0.02 1.0 }

CONSTANT: font $[
    monospace-font
    t >>bold?
    T{ rgba f 0.80 1.0 0.20 1.0 } >>foreground
    T{ rgba f 0.02 0.0 0.02 1.0 } >>background
]

TUPLE: galton < gadget balls { frame initial: 1 } ;

DEFER: on-tick

: <galton-gadget> ( -- gadget )
    galton new bg-color <solid> >>interior V{ } clone >>balls
    dup [ on-tick ] curry f speed milliseconds <timer>
    start-timer ;

: add-ball ( gadget -- )
    dup frame>> balls <
    [ { 250 -20 } swap balls>> [ push ] keep ] when drop ;

: draw-msg ( -- )
    { 10 10 }
    [ font "Press <space> for new animation" draw-text ]
    with-translation ;

: draw-slots ( -- )
    slot-color gl-color { 70 350 } { 70 871 }
    10 [ 2dup gl-line [ { 40 0 } v+ ] bi@ ] times 2drop
    { 70 871 } { 430 871 } gl-line ;

: diamond-side ( loc1 loc2 loc3 -- )
    [ v+ dup ] [ v+ gl-line ] bi* ;

: draw-diamond ( loc color -- )
    gl-color {
        [ { 0 -10 } { 10 10 } ]
        [ { 10 0 } { -10 10 } ]
        [ { 0 10 } { -10 -10 } ]
        [ { -10 0 } { 10 -10 } ]
    } [ diamond-side ] map-compose cleave ;

: draw-peg-row ( loc n -- )
    <iota> [ 40 * 0 2array v+ peg-color draw-diamond ] with
    each ;

: draw-peg-triangle ( -- )
    { 250 40 } 1
    8 [ 2dup draw-peg-row [ { -20 40 } v+ ] dip 1 + ] times
    2drop ;

: draw-balls ( gadget -- )
    balls>> [ ball-color draw-diamond ] each ;

: rand-side ( loc -- loc' ) { { 20 20 } { -20 20 } } random v+ ;

:: collide? ( GADGET BALL -- ? )
    BALL second :> y
    BALL { 0 20 } v+ :> tentative
    { [ y 860 = ] [ tentative GADGET balls>> member? ] } 0|| ;

:: update-ball ( GADGET BALL -- BALL' )
    {
        { [ BALL second pegs member? ] [ BALL rand-side ] }
        { [ GADGET BALL collide? ] [ BALL ] }
        [ BALL { 0 20 } v+ ]
    } cond ;

: update-balls ( gadget -- )
    dup '[ [ _ swap update-ball ] map ] change-balls drop ;

: on-tick ( gadget -- )
    {
        [ dup frame>> odd? [ add-ball ] [ drop ] if ]
        [ relayout-1 ] [ update-balls ]
        [ [ 1 + ] change-frame drop ]
    } cleave ;

M: galton pref-dim* drop { 500 900 } ;

M: galton draw-gadget*
    draw-peg-triangle draw-msg draw-slots draw-balls ;

: com-new ( gadget -- ) V{ } clone >>balls 1 >>frame drop ;

galton "gestures" f {
    { T{ key-down { sym " " } } com-new }
} define-command-map

MAIN-WINDOW: galton-box-animation
    {
        { title "Galton Box Animation" }
        { window-controls
            { normal-title-bar close-button minimize-button } }
    } <galton-gadget> >>gadgets ;
