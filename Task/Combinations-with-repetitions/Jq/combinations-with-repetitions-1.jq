def pick(n):
  def pick(n; m):  # pick n, from m onwards
    if n == 0 then []
    elif m == length then empty
    elif n == 1 then (.[m:][] | [.])
    else ([.[m]] + pick(n-1; m)), pick(n; m+1)
    end;
  pick(n;0) ;
