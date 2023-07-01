# 52-card deck:
def deck:
  [range(127137; 127148), range(127149; 127151),  # Spades
   range(127153; 127164), range(127165; 127167),  # Hearts
   range(127169; 127180), range(127181; 127183),  # Diamonds
   range(127185; 127196), range(127197; 127199)]  # Clubs
  ;

# For splitting a deck into hands :-)
def nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

# Output: a prn in range(0;$n) where $n is ., and $n > 0
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

def knuthShuffle:
  length as $n
  | if $n <= 1 then .
    else {i: $n, a: .}
    | until(.i ==  0;
        .i += -1
        | (.i + 1 | prn) as $j
        | .a[.i] as $t
        | .a[.i] = .a[$j]
        | .a[$j] = $t)
    | .a
    end;

def task:
  [],
  [10,20],
  [10,20,30]
  | knuthShuffle;

task,
 (deck|knuthShuffle | nwise(13) | implode)
