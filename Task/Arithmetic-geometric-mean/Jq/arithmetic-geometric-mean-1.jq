def naive_agm(a; g; tolerance):
  def abs: if . < 0 then -. else . end;
  def _agm:
     # state [an,gn]
     if ((.[0] - .[1])|abs) > tolerance
     then [add/2, ((.[0] * .[1])|sqrt)] | _agm
     else .
     end;
  [a, g] | _agm | .[0] ;
