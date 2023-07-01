prog: [x * 2]
fn: func [x] [do bind prog 'x]
a: fn 2
b: fn 4
subtract b a
