def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

# Display a stream of items in Z-style, n per line
def neatly(s; $n; $width):
  def p: lpad($width);
  foreach s as $x ({n: 1, s:""};
      if .n >= $n
      then .emit = .s + " " + ($x|p)
      | .s = null
      | .n = 1
      else .emit = null
      | .s = .s + " " + ($x|p)
      | .n += 1
      end;
      select(.emit).emit);

# nCk assuming n >= k
def binomial(n; k):
  if k > n / 2 then binomial(n; n-k)
  else reduce range(1; k+1) as $i (1; . * (n - $i + 1) / $i)
  end;
