def ring::add($A; $B):
  if $A|is_modint then modint::add($A; $B)
  elif $A|is_integer then $A + $B
  else "ring::add" | error
  end;

def ring::mul($A; $B):
  if $A|is_modint then modint::mul($A; $B)
  elif $A|is_integer then $A * $B
  else "ring::mul" | error
  end;

def ring::pow($A; $B):
  if $A|is_modint then modint::pow($A; $B)
  elif $A|is_integer then $A|power($B)
  else "ring::pow" | error
  end;

def ring::pp:
  if is_modint then modint::pp
  elif is_integer then .
  else "ring::pp" | error
  end;

def ring::f($x):
  ring::add( ring::add( ring::pow($x; 100); $x); 1);
