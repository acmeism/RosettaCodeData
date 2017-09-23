def ps_equal(s; t; k; eps):
  def abs: if . < 0 then -. else . end;
  reduce range(0;k) as $i
    (true;
     if . then ((($i|s) - ($i|t))|abs) <= eps
     else .
     end);
