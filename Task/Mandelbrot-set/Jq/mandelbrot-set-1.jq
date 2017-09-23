# SVG STUFF
  def svg(id; width; height):
    "<svg width='\(width // "100%")' height='\(height // "100%") '
        id='\(id)'
        xmlns='http://www.w3.org/2000/svg'>";

  def pixel(x;y;r;g;b;a):
    "<circle cx='\(x)' cy='\(y)' r='1' fill='rgb(\(r|floor),\(g|floor),\(b|floor))' />";

# "UNTIL"
  # As soon as "condition" is true, then emit . and stop:
  def do_until(condition; next):
    def u: if condition then . else (next|u) end;
    u;
