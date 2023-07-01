USING: accessors arrays kernel math math.parser namespaces
sequences ui ui.gadgets ui.gadgets.borders ui.gadgets.buttons
ui.gadgets.grids ui.gadgets.labels ui.gadgets.worlds ;
IN: rosetta-code.simple-windowed-application

SYMBOL: n

CONSTANT: on-btn-press [
    parents second n get number>string <label> { 0 1 }
    grid-add drop n inc
]

: build-ui ( -- ) [
    f
    T{ world-attributes { title "Simple windowed application" } }
    clone
    "click me" on-btn-press <border-button> 1array
    "There have been no clicks yet" <label> 1array
    2array <grid>
    { 100 100 } <border>
    >>gadgets
    open-window
] with-ui ;

: main ( -- ) 1 n set build-ui ;

MAIN: main
