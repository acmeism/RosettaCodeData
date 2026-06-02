a: 2 assert [a > 0]          ;== #(true)
a: 2 assert [a > 0 even? a]  ;== #(true)
a: 1 assert [a > 0 even? a]  ;** Script error: assertion failed for: [a > 0 even? a]
