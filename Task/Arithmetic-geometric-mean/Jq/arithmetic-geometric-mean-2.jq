def agm(a; g; tolerance):
  def abs: if . < 0 then -. else . end;
  def _agm:
     # state [an,gn, delta]
     ((.[0] - .[1])|abs) as $delta
     | if $delta == .[2] and $delta < 10e-16 then .
       elif $delta > tolerance
       then [ .[0:2]|add / 2, ((.[0] * .[1])|sqrt), $delta] | _agm
       else .
       end;
  if tolerance <= 0 then error("specified tolerance must be > 0")
  else [a, g, 0] | _agm | .[0]
  end ;

# Example:
agm(1; 1/(2|sqrt); 1e-100)
