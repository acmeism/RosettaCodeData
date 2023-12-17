def ops [a b] {{A: $a, B: $b, "Not A": (not $a), OR: ($a or $b), AND: ($a and $b), XOR: ($a xor $b)}}

[true false] | each {[[true $in] [false $in]]} | flatten | each {ops $in.0 $in.1}
