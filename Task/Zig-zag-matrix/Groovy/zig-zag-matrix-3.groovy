def zz = { n ->
  (0..<n*n).collect { [x:it%n,y:(int)(it/n)] }.sort { c->
    [c.x+c.y, (((c.x+c.y)%2) ? c.y : -c.y)]
  }.with { l -> l.inject(new int[n][n]) { a, c -> a[c.y][c.x] = l.indexOf(c); a } }
}
