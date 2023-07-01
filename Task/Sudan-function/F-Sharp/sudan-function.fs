let rec sudan = function
   0L, x, y -> x + y
  |_, x, 0L -> x
  |n, x, y -> let x' = sudan (n, x, y-1L) in sudan (n-1L, x', x' + y)
printfn "%d\n%d\n%d" (sudan(1L, 13L, 14L)) (sudan(2L, 5L, 1L)) (sudan(2L, 2L, 2L))
