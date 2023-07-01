## Utility Functions
def div($b): (. - (. % $b)) / $b;

def count(s): reduce s as $_ (0; .+1);

def row($i): .[$i];

def col($j): transpose | row($j);

# pretty print
def pp: .[:3][],"", .[3:6][], "", .[6:][];

# Input: 9 x 9 matrix
# Output: linear array corresponding to the specified 3x3 block using IO=0:
#  0,0  0,1  0,2
#  1,0  1,1  1,2
#  2,0  2,1  2,2
def block($i;$j):
  def x: range(0;3) + 3*$i;
  def y: range(0;3) + 3*$j;
  [.[x][y]];

# Output: linear block containing .[$i][$j]
def blockOf($i;$j):
  block($i|div(3); $j|div(3));

# Input: the entire Sudoku matrix
# Output: the update matrix after solving for row $i
def solveRow($i):
  def s:
    (.[$i] | index(0)) as $j
    | if $j
      then ((( [range(1;10)] - row($i)) - col($j)) - blockOf($i;$j) ) as $candidates
      | if $candidates|length == 0 then empty
        else $candidates[] as $x
        | .[$i][$j] = $x
        | s
        end
      else .
      end;
   s;

def distinct: map(select(. != 0)) | length - (unique|length) == 0;

# Is the Sudoku valid?
def valid:
  . as $in
  | length as $l
  | all(.[]; distinct) and
    all( range(0;9); . as $i | $in | col($i) | distinct ) and
    all( range(0;3); . as $i | all(range(0;3); . as $j
         | $in | block($i;$j) | distinct ));

# input: the full puzzle in its current state
# output: null if there is no candidate next row
def next_row:
  first( range(0; length) as $i | select(row($i)|index(0)) | $i) // null;

def solve(problem):
  def s:
    next_row as $ix
    | if $ix then solveRow($ix) | s
      else .
      end;
  if problem|valid then first(problem|s) | pp
  else "The Sukoku puzzle is invalid."
  end;

# Rating Program: dukuso's suexratt
# Rating: 3311
# Poster: tarek
# Label: tarx0134
# ........8..3...4...9..2..6.....79.......612...6.5.2.7...8...5...1.....2.4.5.....3
def tarx0134:
  [[0,0,0,0,0,0,0,0,8],
   [0,0,3,0,0,0,4,0,0],
   [0,9,0,0,2,0,0,6,0],
   [0,0,0,0,7,9,0,0,0],
   [0,0,0,0,6,1,2,0,0],
   [0,6,0,5,0,2,0,7,0],
   [0,0,8,0,0,0,5,0,0],
   [0,1,0,0,0,0,0,2,0],
   [4,0,5,0,0,0,0,0,3]];

# An invalid puzzle, for checking `valid`:
def unsolvable:
  [[3,9,4,3,0,2,6,7,0],
   [0,0,0,3,0,0,4,0,0],
   [5,0,0,6,9,0,0,2,0],
   [0,4,5,0,0,0,9,0,0],
   [6,0,0,0,0,0,0,0,7],
   [0,0,7,0,0,0,5,8,0],
   [0,1,0,0,6,7,0,0,8],
   [0,0,9,0,0,8,0,0,0],
   [0,2,6,4,0,0,7,3,5]] ;

solve(tarx0134)
