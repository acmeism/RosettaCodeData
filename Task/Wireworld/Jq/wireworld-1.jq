def lines: split("\n")|length;

def cols: split("\n")[0]|length + 1;  # allow for the newline

# Is there an "H" at [x,y] relative to position i, assuming the width is w?
# Input is an array; 72 is "H"
def isH(x; y; i; w): if .[i+ w*y + x] == 72 then 1 else 0 end;

def neighborhood(i;w):
  isH(-1; -1; i; w) + isH(0; -1; i; w) + isH(1; -1; i; w) +
  isH(-1;  0; i; w)                    + isH(1;  0; i; w) +
  isH(-1;  1; i; w) + isH(0;  1; i; w) + isH(1;  1; i; w) ;

# The basic rules:
# Input: a world
# Output: the next state of .[i]
def evolve(i; width) :
  # "Ht. " | explode => [ 72,  116,  46,  32 ]
  .[i] as $c
  | if   $c ==  32 then $c           # " " => " "
    elif $c == 116 then 46           # "t" => "."
    elif $c ==  72 then 116          # "H" => "t"
    elif $c ==  46 then              # "."
      # updates are "simultaneous" i.e. relative to $world
      neighborhood(i; width) as $sum
      | (if [1,2]|index($sum) then 72 else . end)  # "H"
    else $c
    end ;

# [world, lines, cols] | next(w) => [world, lines, cols]
def next:
  .[0] as $world | .[1] as $lines | .[2] as $w
  | reduce range(0; $world|length) as $i
    ($world;
      $world | evolve($i; $w) as $next
      | if  .[$i] == $next then . else .[$i] = $next end )
  | [., $lines, $w] ; #
