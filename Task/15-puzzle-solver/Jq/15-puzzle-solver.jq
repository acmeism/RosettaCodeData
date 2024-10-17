# The following may be omitted if using the C implementation
# or if the debug messages are deleted.
def debug(msg): (msg | tostring | debug | empty), .;

### Generic functions

def array_swap($i; $j):
  if $j < $i then array_swap($j;$i)
  elif $i == $j then .
  else .[:$i] + [.[$j]] + .[$i+1:$j] + [.[$i]] + .[$j+1:]
  end ;

def sum(s): reduce s as $x (0; . + $x);

### The 15-Puzzle

# manhattan distance between points $ix and $iy where these are indices in the flat array
def distance($ix; $jx):
  def row: ./4 | floor;
  def col: . % 4;
  [$ix, $jx]
  | map(row) as $mr  # [$ri, $rj]
  | map(col) as $mc  # [$ci, $cj]
  | [$mr[0] - $mr[1], $mc[0] - $mc[1]]
  | map(length) # i.e. abs
  | add;

# What is the Manhattan distance between the position of $tile in the goal
# and the location corresponding to index $ix, where $ix is in range(0;16)
def manhattan($tile; $ix):
  .position[$tile|tostring] as $jx
  | distance($ix; $jx);

# The total of the discrepancies
def total_manhattan_distance:
  sum( range(0;16) as $p | .board[$p] as $tile | select($tile != 0) | manhattan($tile; $p) )
  | debug;

# Input:
#  .goal is the desired board (flat array)
#  .position is the JSON object mapping tiles to the goal index
#  .zero is the location of 0
#  .board is the current state of the board (flat array)
#  .distance is incremented by $delta after each move
#  .seen is our memory
# If allowed, move the zero tile to $p where $p has been properly specified in relation to .zero;
# otherwise emit empty
def move($p):
  if $p >= 0 and $p < 16
  then .board[$p] as $tile
  # Are we making things worse off?
  | (manhattan($tile; .zero) - manhattan($tile; $p)) as $delta
  | if $delta > 0 and .distance > (.N - .n)
    then if .n >= .N then debug({n, N, distance,sequence: (.sequence|length)}) end | empty
    else # make the move
    .zero as $zero
    | (.board | array_swap($zero; $p)) as $candidate
    | ($candidate|tostring) as $s
    | if .seen[$s]
      then empty
      else .board = $candidate
      | .zero = $p
      | .n += 1
      | .seen[$s] = true
      end
    end
  # We should only reach here if the move has been made
  | if $delta != 0
    then .distance += $delta
    end
  else empty
  end
;

def row: . / 4 | floor;
def col: . % 4;

def up:
  if (.zero | row) == 0 then empty
  else move(.zero - 4)
  | .sequence += ["u"]
  end;

def down:
  if (.zero | row) == 3 then empty
  else move(.zero + 4)
  | .sequence += ["d"]
  end;

def left:
  if (.zero|col) == 0 then empty
  else move(.zero - 1)
  | .sequence += ["l"]
  end;

def right:
  if (.zero|col) == 3 then empty
  else move(.zero + 1)
  | .sequence += ["r"]
  end;

# $array is a permutation of range(0;16), e.g. the goal
# Output: a JSON object such that .[$tile] is the position of $tile in the goal
def positions($array):
  reduce range(0; $array|length) as $i ({}; . + {($array[$i]|tostring): $i});

# map a string of lowercase hex digits to an array of decimals
def symbols2array: explode | map(if . > 96 then .-87 else .-48 end);

# $start should be a string of length 16 representing the starting state;
# the goal is: "123456789abcdef0"
def init($start):
  if $start|length == 16 then . else error end
  | [range(1;16), 0] as $init
  | {goal: $init,
     position: positions($init),
     distance: 0,
     n: 0,           # number of moves so far
     sequence: [],   # the sequence of moves so far
     seen: {}
  }
  | .board =  ($start | symbols2array)
  | .zero = (.board|index(0))
  | (.board|tostring) as $s
  | .seen[$s] = true
;

# Output: If the move of the zero tile to $p is legal in one step,
#         then emit manhattan($tile; .zero) - manhattan($tile; $p)
#         where $tile is the tile at $p;
#         otherwise: null
def delta_move($p):
  if $p >= 0 and $p < 16
  then distance($p; .zero) as $base
  | if ($base|length) == 1  # abs
    then .board[$p] as $tile
    | manhattan($tile; .zero) - manhattan($tile; $p)
    else null
    end
  else null
  end ;

# For comparing the possible moves:
def moves:
   {"u": delta_move( .zero - 4),
    "d": delta_move( .zero + 4),
    "l": delta_move( .zero - 1),
    "r": delta_move( .zero + 1) }
   | to_entries
   | map(select( .value ) )
   | sort_by(.value)
   ;


# input: the output of moves
def execute($moves):
  ($moves[] |.key) as $key
  |   if $key == "l" then left
    elif $key == "r" then right
    elif $key == "u" then up
    elif $key == "d" then down
    else empty
    end;

# $N is the maximum number of moves allowed
# Input: as per `input`; .n is the number of moves so far
def possible_moves($N):
  def possible_moves:
    if .board == .goal then .  # a solution
    elif (.sequence|length) >= $N then empty
    else .sequence[-1] as $lastmove
    | if   $lastmove == "l"  then execute(moves | map(select(.key != "r")))
      elif $lastmove == "r"  then execute(moves | map(select(.key != "l")))
      elif $lastmove == "u"  then execute(moves | map(select(.key != "d")))
      elif $lastmove == "d"  then execute(moves | map(select(.key != "u")))
      else                        execute(moves)
      end
    | possible_moves
    end ;
  possible_moves;

def solve($goal):
  init($goal)
  | total_manhattan_distance as $d
  | first( range($d; 100) as $n
           | .N = $n
           | .distance = $d
           | debug("before: n=\($n) distance = \($d))")
           | possible_moves($n)
           | .sequence | join("") ) ;

solve("fe169b4c0a73d852")
