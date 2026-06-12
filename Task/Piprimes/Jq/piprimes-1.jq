def count(s): reduce s as $x (null; .+1);

def emit_until(cond; stream):
  label $out | stream | if cond then break $out else . end;

def next_prime:
  if . == 2 then 3
  else first(range(.+2; infinite; 2) | select(is_prime))
  end;
