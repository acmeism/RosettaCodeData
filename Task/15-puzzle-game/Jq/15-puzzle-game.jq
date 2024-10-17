include "MRG32k3a" {search: "."};  # see above

# The following may be omitted if using the C implementation of jq
def _nwise($n):
  def n: if length <= $n then . else .[0:$n] , (.[$n:] | n) end;
  n;

### Generic utilities

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

# tabular print
def tprint($columns; $width):
  reduce _nwise($columns) as $row ("";
     . + ($row|map(lpad($width)) | join(" ")) + "\n" );

def array_swap($i; $j):
  if $j < $i then array_swap($j;$i)
  elif $i == $j then .
  else .[:$i] + [.[$j]] + .[$i+1:$j] + [.[$i]] + .[$j+1:]
  end ;

### Pre-requisite: MRG32k3a
# Input: an array to be shuffled
# Output: the shuffled array using a seed based on `now`
def shuffle:
  { prng: (seed(now | tostring | sub("^.*[.]";"") | tonumber)),
    array: . }
  | knuthShuffle
  | .array;

### 15-Puzzle

# Pretty-print the board
def pp:
  .board | map(if . == 0 then "" end) | tprint(4;3);

def row: ./4 | floor;
def col: . % 4;

def move($p):
  .zero as $zero
  | (.board |= array_swap($zero; $p))
  | .zero = $p
  | .n += 1 ;

def SolvedBoard: [range(1;16), 0];

# Output: {goal, n, board, zero}
def init($easy):
  SolvedBoard as $init
  | { goal: $init,
      n: 0,          # number of moves so far
      board: ($init | if $easy then array_swap(14;15) else shuffle end)
    }
  | .zero = (.board|index(0)) ;

# If $m is a valid single-letter move, then emit the corresponding
# index of the proposed new position.
# Input must include .zero
def isValidMove($m):
  if   ($m == "u") then if (.zero|row) != 0 then .zero - 4 else false end
  elif ($m == "d") then if (.zero|row) != 3 then .zero + 4 else false end
  elif ($m == "r") then if (.zero|col) != 3 then .zero + 1 else false end
  elif ($m == "l") then if (.zero|col) != 0 then .zero - 1 else false end
  else false
  end;

def instructions:
  "Please enter \"u\", \"d\", \"l\", or \"r\" to move the empty cell",
  "up, down, left, or right. You can also enter \"q\" to quit.",
  "Upper or lowercase is accepted and only the first character",
  "is important, so for example you could enter `up` instead of `u`.";

def play($easy):
  def prompt:
    pp,
    if .board == .goal then "Congratulations. You solved the puzzle in \(.n) moves."
    else
      "Enter move #\(.n + 1) (u, d, l, r or q): ",
      ( (limit(1;inputs)[:1]|ascii_downcase) as $m
        | if $m == "q" then halt
          else isValidMove($m) as $p
          | if $p then move($p) | prompt
            else "Invalid move.", prompt
            end
          end)
    end;

  instructions,
  (init($easy) | prompt);

play(ARGS.named.easy)
