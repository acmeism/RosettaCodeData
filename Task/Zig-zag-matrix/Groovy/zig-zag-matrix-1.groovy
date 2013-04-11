def zz = { n ->
  grid = new int[n][n]
  i = 0
  for (d in 1..n*2) {
    (x, y) = [Math.max(0, d - n), Math.min(n - 1, d - 1)]
     Math.min(d, n*2 - d).times {
       grid[d%2?y-it:x+it][d%2?x+it:y-it] = i++;
      }
  }
  grid
}
