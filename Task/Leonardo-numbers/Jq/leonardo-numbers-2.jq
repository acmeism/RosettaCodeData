def Leonardo(zero; one; incr):
  def leo(n):
    if .[n] then .
    else leo(n-1)   # optimization of leo(n-2)|leo(n-1)
    | .[n] = .[n-1] + .[n-2] +  incr
    end;
  . as $n | [zero,one] | leo($n) | .[$n];
