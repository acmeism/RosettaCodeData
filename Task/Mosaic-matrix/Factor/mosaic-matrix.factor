USING: accessors colors kernel math math.matrices ui
ui.gadgets.grid-lines ui.gadgets.grids ui.gadgets.labels
ui.pens.solid ;
IN: mosaic

: <square> ( m n -- gadget )
    + 2 mod 0 = [
        " 1 " <label> COLOR: AntiqueWhite2 <solid> >>interior
        [ 50 >>size ] change-font
    ] [ "" <label> ] if ;

: <checkerboard> ( n -- gadget )
    dup [ <square> ] <matrix-by-indices> <grid>
    COLOR: gray <grid-lines> >>boundary ;

MAIN: [ 8 <checkerboard> "Mosaic" open-window ]
