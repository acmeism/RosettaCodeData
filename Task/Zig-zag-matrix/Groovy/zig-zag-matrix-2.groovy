def zz = { n->
  move = { i, j -> j < n - 1 ? [i <= 0 ? 0 : i-1, j+1] : [i+1, j] }
  grid = new int[n][n]
  (x, y) = [0, 0]
  (n**2).times {
    grid[y][x] = it
    if ((x+y)%2) (x,y) = move(x,y)
    else (y,x) = move(y,x)
  }
  grid
}
