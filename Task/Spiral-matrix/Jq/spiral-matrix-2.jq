def spiral(n):
  # we just placed m at i,j, and we are moving in the direction d
  def _next(i; j; m; d):
    if m == (n*n) - 1 then .
    elif .[i+d[0]][j+d[1]] == false
      then .[i+d[0]][j+d[1]]   = m+1 | _next(i+d[0]; j+d[1]; m+1; d)
    else (d|right) as $d
       |   .[i+$d[0]][j+$d[1]] = m+1 | _next(i+$d[0]; j+$d[1]; m+1; $d)
    end;

  matrix(n;n;false) | .[0][0] = 0 | _next(0;0;0; [0,1]) ;

# Example
spiral(5) | neatly(3)
