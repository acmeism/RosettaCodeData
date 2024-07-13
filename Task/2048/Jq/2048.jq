include "MRG32k3a" {search: "."};  # see comment above

### Generic functions

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# Create an m x n matrix with initial values specified by .
def matrix($m; $n):
  if $m == 0 then []
  else . as $init
  | if $m == 1 then [range(0;$n) | $init]
    elif $m > 0 then
    matrix(1; $n) as $row
    | [range(0; $m) | $row ]
    else error("matrix\($m);\($n)) invalid")
    end
  end;


### The 2048 Game
# Left-squish the input array in accordance with the game requirements for a single row
def squish:
  def squish($n):
    def s:
      if length == 0 then [range(0;$n)|null]
      elif .[0] == null then .[1:] | s
      elif length == 1 then . + [range(0; $n - 1)|null]
      elif .[0] == .[1] then [.[0] + .[1]] + (.[2:]|squish($n-1))
      else .[0:1] + (.[1:]|squish($n-1))
      end;
    s;
  squish(length);

# Input: a matrix of rows
def squish_left:
  [.[] | squish];

def squish_right:
  [.[] | reverse | squish | reverse];

def squish_up:
  transpose
  | [.[] | squish]
  | transpose;

def squish_down:
  transpose
  | [.[] | reverse | squish | reverse]
  | transpose;

# Gather the [i,j] co-ordinates of all the null values in the input matrix
def gather:
  if length == 0 then error end
  | (.[0] | length) as $cols
  | [range(0;length) as $i
     | range(0; $cols) as $j
     | select(.[$i][$j] == null) | [$i,$j]]
  | if length == 0 then error end ;

# Input: {matrix}
# Add a random 2 or 4 if possible, else error
# Output: includes .prng for the PRN generator
def add_random:
  (.matrix | gather) as $gather
  | ($gather | length) as $n
  | if $n == 0 then error end
  | if .prng == null then .prng = seed(now | tostring | sub("^.*[.]";"") | tonumber) end
  | .prng |= nextFloat
  | $gather[.prng.nextFloat * $n | trunc] as [$i,$j]
  | .prng |= nextFloat
  |  (if (.prng.nextFloat) < 0.1 then 4 else 2 end) as $exmachina
  | .matrix[$i][$j] = $exmachina ;

def prompt: "[ijkl] or [wasd] or q to quit or n to restart:";

def direction:
  {"i": "up", "j": "left", "k": "down", "l": "right",
   "w": "up", "a": "left", "s": "down", "d": "right",
   "q": "quit",
   "n": "restart"
  };

# Recognize $goal as the goal
def play($goal):

  # Pretty print
  def pp:
    .matrix[] | map(. // "." | lpad(4))  | join(" ");

  def won:
    any(.matrix[][]; . == $goal);

  def lost:
    .matrix
    | (squish_left == .) and (squish_right == .) and
      (squish_up   == .) and (squish_down == .);

  def round:
    pp,
    if lost then "Sorry!  Better luck next time.", play($goal)
    else prompt,
    ( (try input catch halt) as $in
    | .matrix as $matrix   # for checking if a move is legal
    | .emit = null
    | direction[$in | ascii_downcase] as $direction
    | if   $direction == "up"    then .matrix |= squish_up
      elif $direction == "down"  then .matrix |= squish_down
      elif $direction == "left"  then .matrix |= squish_left
      elif $direction == "right" then .matrix |= squish_right
      elif $direction == "quit"  then .emit = "bye"
      elif $direction == "restart" then .emit = "restart"
      else .emit = "unknown direction \($direction) ... please try again."
      end
    | if   .emit == "bye"     then .emit, halt
      elif .emit == "restart" then "Restarting...", play($goal)
      elif .emit != null      then .emit, round
      elif .matrix == $matrix then "Disallowed direction!  Please try again.", round
      elif won then pp, "Congratulations!", play($goal)
      else add_random | round
      end)
    end;

  { matrix: (null | matrix(4;4))}
  | .matrix[2] = [null,2,2,2]
  | round;

play(2048)
