# cantor(width; height)
def cantor($w; $h):
  def init: [range(0; $h) | [range(0; $w) | "*"]];

  def cantor($start; $leng; $ix):
    ($leng/3|floor) as $seg
    | if $seg == 0 then .
      else reduce range($ix; $h) as $i (.;
             reduce range($start+$seg; $start + 2*$seg) as $j (.; .[$i][$j] = " "))
      | cantor($start; $seg; $ix+1)
      | cantor($start + 2*$seg; $seg; $ix+1)
    end ;
  init | cantor(0; $w; 1);

def pp: .[] | join("");

cantor($width; $height)
| pp
