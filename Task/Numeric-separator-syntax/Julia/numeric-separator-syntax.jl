    julia> 2_9
    29

    julia> 2_9_9_0
    2990

    julia> 2_9_9.0_01
    299.001

    julia> 1._01
    ERROR: syntax: invalid numeric constant "1._"

    julia> -1_0
    -10

    julia> -_10
    ERROR: UndefVarError: _10 not defined
    Stacktrace:
     [1] top-level scope at none:0

    julia> 0x34_ff
    0x34ff

    julia> 0x_34ff
    ERROR: syntax: invalid numeric constant "0x_"

    julia> 10_000_000
    10000000

    julia> 10__000__000
    ERROR: UndefVarError: __000__000 not defined
