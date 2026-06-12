USING: accessors kernel L-system sequences ui ;

: curve ( L-system -- L-system )
    L-parser-dialect
    { "G" [ dup length>> draw-forward ] } suffix >>commands
    [ 45 >>angle ] >>turtle-values
    "F--XF--F--XF" >>axiom
    {
        { "X" "XF+G+XF--F--XF+G+X" }
    } >>rules ;

[ <L-system> curve "Sierpinski curve" open-window ] with-ui
