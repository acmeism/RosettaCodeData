USING: accessors calendar colors.constants combinators kernel
locals math math.vectors opengl timers ui ui.gadgets
ui.gadgets.worlds ui.pens.solid ui.render ;
IN: rosetta-code.vibrating-squares

TUPLE: vibrating < gadget
    { old-color initial: COLOR: black }
    { new-color initial: COLOR: red }
    { frame initial: 0 } ;

DEFER: on-tick

: <vibrating-gadget> ( -- gadget )
    vibrating new COLOR: black <solid> >>interior COLOR: red
    >>new-color COLOR: black >>old-color dup [ on-tick ] curry f
    250 milliseconds <timer> start-timer ;

M: vibrating pref-dim* drop { 420 420 } ;

: draw-squares ( loc dim n -- loc' dim' )
    [ 2dup gl-rect [ { 10 10 } v+ ] [ { -20 -20 } v+ ] bi* ]
    times ;

M:: vibrating draw-gadget* ( GADGET -- )
    GADGET frame>> 20 mod :> n
    GADGET new-color>> gl-color
    { 10 10 } { 400 400 } n draw-squares
    GADGET old-color>> gl-color
    20 n - draw-squares 2drop ;

:: on-tick ( GADGET -- )
    GADGET relayout-1
    GADGET [ 1 + ] change-frame frame>> 20 mod zero? [
        GADGET new-color>> GADGET old-color<<
        GADGET new-color>> {
            { COLOR: red [ COLOR: green ] }
            { COLOR: green [ COLOR: blue ] }
            [ drop COLOR: red ]
        } case GADGET new-color<<
    ] when ;

MAIN-WINDOW: vibrating-squares
    {
        { title "Vibrating Squares" }
        { window-controls
            { normal-title-bar close-button minimize-button } }
    } <vibrating-gadget> >>gadgets ;
