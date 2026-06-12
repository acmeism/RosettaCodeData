def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def gcd(a; b):
  # subfunction expects [a,b] as input
  # i.e. a ~ .[0] and b ~ .[1]
  def rgcd: if .[1] == 0 then .[0]
         else [.[1], .[0] % .[1]] | rgcd
         end;
  [a,b] | rgcd;
