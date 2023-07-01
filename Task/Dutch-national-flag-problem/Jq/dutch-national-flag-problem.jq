# Output: a PRN in range(0; .)
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def colors:   ["Red", "White", "Blue"];

def colorMap: {"Red": 0, "White": 1, "Blue": 2 };

def task($nballs):
  def sorted:
    . == sort_by(colorMap[.]);
  def generate:
    [range(0; $nballs) | colors[ 3|prn ] ]
    | if sorted then generate else . end;
  generate
  | "Before sorting : \(.)",
    "After sorting  : \(sort_by(colorMap[.]))" ;

task(9)
