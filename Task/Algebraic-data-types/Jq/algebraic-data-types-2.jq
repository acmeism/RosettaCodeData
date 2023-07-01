include "bindings" {search: "."};

def E: [];  # the empty node
# Each nonempty node is an array: [Color, Left, Value, Right]
# where Left and Right are nodes.

def B: "⚫";
def R: "🔴";

def b(x): bindings({} | x) // empty;

# Input: [$color, $left, $value, $right]
def balance:
  def node: [R, [B, .a, .x, .b], .y, [B, .c, .z, .d]];

  (   b([B, [R, [R,  {a}, {x}, {x}], {y}, {c}],  {z}, {d}])
   // b([B, [R, {a}, {x}, [R,  {b},  {y}, {c}]], {z}, {d}])
   // b([B, {a},{x}, [R,  [R,  {b},  {y}, {c}],  {z}, {d}]])
   // b([B, {a},{x}, [R,  {b}, {y},  [R,  {c},   {z}, {d}]]])
   | node) // . ;

# Input: a node
def ins($x):
  if . == E then [R, E, $x, E]
  else . as [$col, $left, $y, $right]
  | if   $x < $y then [ $col, ($left|ins($x)), $y, $right]            | balance
    elif $x > $y then [ $col, $left,           $y, ($right|ins($x)) ] | balance
    else $left
    end
  end;

# insert(Value) into .
def insert($x):
  ins($x) as [$col, $left, $y, $right]
  | [ B, $left, $y, $right] ;

def pp: walk( if type == "array" then map(select(length>0)) else . end);

def task($n):
  reduce range(0; $n) as $i (E; insert($i));

task(16) | pp
