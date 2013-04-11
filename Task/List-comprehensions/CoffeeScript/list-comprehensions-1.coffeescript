flatten = (arr) -> arr.reduce ((memo, b) -> memo.concat b), []

pyth = (n) ->
  flatten (for x in [1..n]
    flatten (for y in [x..n]
      for z in [y..n] when x*x + y*y is z*z
        [x, y, z]
    ))

console.dir pyth 20
