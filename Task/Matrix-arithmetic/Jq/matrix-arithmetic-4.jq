# Requires lup/0
def det:
  def product_diagonal:
    . as $m | reduce range(0;length) as $i (1; . * $m[$i][$i]);
  def tidy: if . == -0 then 0 else . end;
  lup
  | (.[0]|product_diagonal) as $l
  | if $l == 0 then 0 else $l * (.[1]|product_diagonal) | tidy end ;
