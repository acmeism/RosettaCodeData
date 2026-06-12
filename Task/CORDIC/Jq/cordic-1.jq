# like while/2 but emit the final term rather than the first one
def whilst(cond; update):
  def _whilst:
    if cond then update | (., _whilst) else empty end;
  _whilst;

# Simplistic approach to rounding:
def round($ndec): pow(10;$ndec) as $p | . * $p | round / $p;

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;
