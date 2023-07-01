USING: accessors kernel L-system sequences ui ;

: square-curve ( L-system -- L-system )
    L-parser-dialect >>commands
    [ 90 >>angle ] >>turtle-values
    "F+XF+F+XF" >>axiom
    {
        { "X" "XF-F+F-XF+F+XF-F+F-X" }
    } >>rules ;

[
    <L-system> square-curve
    "Sierpinski square curve" open-window
] with-ui
