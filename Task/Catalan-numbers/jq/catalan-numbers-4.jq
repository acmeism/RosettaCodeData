def catalan_series(max):
  def _catalan: # state: [n, catalan(n)]
    if .[0] > max then empty
    else .,
      ((.[0] + 1) as $n | .[1] as $cp
       | [$n,  (2 * (2*$n - 1) * $cp) / ($n + 1) ] | _catalan)
    end;
  [0,1] | _catalan;
