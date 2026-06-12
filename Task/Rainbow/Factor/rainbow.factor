USING: colors grouping hashtables io.styles qw sequences ui
ui.gadgets.panes ;

"RAINBOW" 1 group
qw{ red orange yellow green blue indigo violet } [
    [ named-color foreground associate format ] 2each
] make-pane "Rainbow" open-window
