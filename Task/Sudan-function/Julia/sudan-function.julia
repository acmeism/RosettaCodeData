using Memoize

@memoize function sudan(n, x, y)
   return n == 0 ? x + y : y == 0 ? x : sudan(n - 1, sudan(n, x, y - 1), sudan(n, x, y - 1) + y)
end

foreach(t -> println("sudan($(t[1]), $(t[2]), $(t[3])) = ",
   sudan(t[1], t[2], t[3])), ((0,0,0), (1,1,1), (2,1,1), (3,1,1), (2,2,1)))
