import strutils

func sumTo(n: Natural): Natural = n * (n+1) div 2

func coord2num(row, col, N: Natural): Natural =
  var start, offset: Natural
  let diag = col + row
  if diag < N:
    start = sumTo(diag)
    offset = if diag mod 2 == 0: col else: row
  else:
    # N * (2*diag+1-N) - sumTo(diag), but with smaller itermediates
    start = N*N - sumTo(2*N-1-diag)
    offset = N-1 - (if diag mod 2 == 0: row else: col)
  start + offset

let N = 6
let width = (N*N).`$`.len + 1
for row in 0 ..< N:
  for col in 0 ..< N:
    stdout.write(coord2num(row, col, N).`$`.align(width))
  stdout.write("\n")
