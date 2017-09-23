def zigzag(n):

  # unless m == n*n, place m at (i,j), pointing
  # in the direction d, where d = [drow, dcolumn]:
  def _next(i; j; m; d):
    if m == (n*n) then . else .[i][j] = m end
    | if m == (n*n) - 1 then .
      elif i == n-1 then if j+1 < n then .[i][j+1] = m+1 | _next(i-1; j+2; m+2; [-1, 1]) else . end
      elif i ==   0 then if j+1 < n then .[i][j+1] = m+1 | _next(i+1; j  ; m+2; [ 1,-1])
                         else            .[i+1][j] = m+1 | _next(i+2; j-1; m+2; [ 1,-1]) end
      elif j == n-1 then if i+1 < n then .[i+1][j] = m+1 | _next(i+2; j-1; m+2; [ 1,-1]) else . end
      elif j ==   0 then if i+1 < n then .[i+1][j] = m+1 | _next(i;   j+1; m+2; [-1, 1])
                         else            .[i][j+1] = m+1 | _next(i-1; j+1; m+2; [-1, 1]) end
      else _next(i+ d[0]; j+ d[1]; m+1;  d)
      end ;
  matrix(n;n;-1) | _next(0;0; 0; [0,1]) ;

# Example
zigzag(5) | neatly(4)
