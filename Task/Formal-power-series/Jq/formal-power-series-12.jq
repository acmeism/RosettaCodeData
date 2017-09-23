# Multiply two power series, s and t:
def M(s;t):
  . as $i | reduce range(0; 1+$i) as $k
    (0; . + ($k|s) * (($i - $k)|t));

# Derivative of the power series, s:
def D(s): (. + 1) as $i | $i * ($i|s);

# Integral of the power series, s,
# with an integration constant equal to 0:
def I(s):
  . as $i
  | if $i == 0 then 0 else (($i-1)|s) /$i end;
