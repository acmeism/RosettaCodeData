flatten = (arr) -> arr.reduce ((memo, b) -> memo.concat b), []

pyth = (n) ->
  flatten (for x in [1..n]
    flatten (for y in [x..n]
      for z in [y..n] when x*x + y*y is z*z
        [x, y, z]
    ))
# pyth can also be written more concisely as
# pyth = (n) -> flatten (flatten ([x, y, z] for z in [y..n] when x*x + y*y is z*z for y in [x..n]) for x in [1..n])

console.dir pyth 20
