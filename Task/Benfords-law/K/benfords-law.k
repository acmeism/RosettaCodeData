law: {(`ln 1 + 1%x) % `ln 10}
tally: #' = {*$x}' +\[1000; 0.0; 1.0]

`0: (8$"digit"), (12$"Expected"), "Actual"

row: {`0: (-3$$x), (-13$7#$law x), -10$"0.", $tally[*$x]}
nop: 9 {row x; x + 1}/ 1
