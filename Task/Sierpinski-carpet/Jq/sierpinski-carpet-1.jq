def inCarpet(x; y):
  x as $x | y as $y |
  if $x == -1 or $y == -1 then "\n"
  elif $x == 0 or $y == 0 then "*"
  elif ($x % 3) == 1 and ($y % 3) == 1 then " "
  else inCarpet($x/3 | floor; $y/3 | floor)
  end;

def ipow(n):
  . as $in | reduce range(0;n) as $i (1; . * $in);

def carpet(n):
  (3|ipow(n)) as $power
  | [ inCarpet( range(0; $power) ; range(0; $power), -1 )]
  | join("") ;


carpet(3)
