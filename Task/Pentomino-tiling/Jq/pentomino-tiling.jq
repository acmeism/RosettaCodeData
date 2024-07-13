# Output: a PRN in range(0; .)
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

### Generic functions

def array($n): . as $in | [range(0;$n)|$in];

def array_swap($i; $j):
  if $i < $j then array_swap($j;$i)
  elif $i == $j then .
  else .[$i] as $t | .[:$j] + [$t] + .[$j:$i] + .[$i + 1:]
  end ;

### Pentominos

def F: [
    [1, -1, 1,  0, 1, 1, 2,  1], [0,  1, 1, -1, 1,  0, 2, 0],
    [1,  0, 1,  1, 1, 2, 2,  1], [1,  0, 1,  1, 2, -1, 2, 0],
    [1, -2, 1, -1, 1, 0, 2, -1], [0,  1, 1,  1, 1,  2, 2, 1],
    [1, -1, 1,  0, 1, 1, 2, -1], [1, -1, 1,  0, 2,  0, 2, 1]
];

def I: [
    [0, 1, 0, 2, 0, 3, 0, 4], [1, 0, 2, 0, 3, 0, 4, 0]
];

def L: [
    [1, 0, 1, 1, 1, 2, 1, 3], [1,  0, 2,  0, 3, -1, 3, 0],
    [0, 1, 0, 2, 0, 3, 1, 3], [0,  1, 1,  0, 2,  0, 3, 0],
    [0, 1, 1, 1, 2, 1, 3, 1], [0,  1, 0,  2, 0,  3, 1, 0],
    [1, 0, 2, 0, 3, 0, 3, 1], [1, -3, 1, -2, 1, -1, 1, 0]
];

def N: [
    [0, 1, 1, -2, 1, -1, 1, 0], [1,  0, 1,  1, 2,  1, 3,  1],
    [0, 1, 0,  2, 1, -1, 1, 0], [1,  0, 2,  0, 2,  1, 3,  1],
    [0, 1, 1,  1, 1,  2, 1, 3], [1,  0, 2, -1, 2,  0, 3, -1],
    [0, 1, 0,  2, 1,  2, 1, 3], [1, -1, 1,  0, 2, -1, 3, -1]
];

def P: [
    [0, 1, 1, 0, 1, 1, 2, 1], [0,  1, 0,  2, 1,  0, 1, 1],
    [1, 0, 1, 1, 2, 0, 2, 1], [0,  1, 1, -1, 1,  0, 1, 1],
    [0, 1, 1, 0, 1, 1, 1, 2], [1, -1, 1,  0, 2, -1, 2, 0],
    [0, 1, 0, 2, 1, 1, 1, 2], [0,  1, 1,  0, 1,  1, 2, 0]
];

def T: [
    [0, 1, 0,  2, 1, 1, 2, 1], [1, -2, 1, -1, 1, 0, 2, 0],
    [1, 0, 2, -1, 2, 0, 2, 1], [1,  0, 1,  1, 1, 2, 2, 0]
];

def U: [
    [0, 1, 0, 2, 1, 0, 1, 2], [0, 1, 1, 1, 2, 0, 2, 1],
    [0, 2, 1, 0, 1, 1, 1, 2], [0, 1, 1, 0, 2, 0, 2, 1]
];

def V: [
    [1, 0, 2,  0, 2,  1, 2, 2], [0, 1, 0, 2, 1, 0, 2, 0],
    [1, 0, 2, -2, 2, -1, 2, 0], [0, 1, 0, 2, 1, 2, 2, 2]
];

def W: [
    [1, 0, 1, 1, 2, 1, 2, 2], [1, -1, 1,  0, 2, -2, 2, -1],
    [0, 1, 1, 1, 1, 2, 2, 2], [0,  1, 1, -1, 1,  0, 2, -1]
];

def X: [[1, -1, 1, 0, 1, 1, 2, 0]];

def Y: [
    [1, -2, 1, -1, 1, 0, 1, 1], [1, -1, 1,  0, 2, 0, 3, 0],
    [0,  1, 0,  2, 0, 3, 1, 1], [1,  0, 2,  0, 2, 1, 3, 0],
    [0,  1, 0,  2, 0, 3, 1, 2], [1,  0, 1,  1, 2, 0, 3, 0],
    [1, -1, 1,  0, 1, 1, 1, 2], [1,  0, 2, -1, 2, 0, 3, 0]
];

def Z: [
    [0, 1, 1, 0, 2, -1, 2, 0], [1,  0, 1,  1, 1, 2, 2,  2],
    [0, 1, 1, 1, 2,  1, 2, 2], [1, -2, 1, -1, 1, 0, 2, -2]
];

def shapes: [F, I, L, N, P, T, U, V, W, X, Y, Z];

def symbols: "FILNPTUVWXYZ-" | split("");

def nRows:  8;
def nCols:  8;
def blank: 12;

def printResult:
  .symbols as $symbols
  | .grid[] as $row
  | reduce $row[] as $i (""; . + $symbols[$i]);

# Input: {grid}
def placeOrientation($o; $r; $c; $shapeIndex):
  .grid[$r][$c] = $shapeIndex
   | reduce range(0; $o|length; 2) as $io (.;
      .grid[$r + $o[$io]][$c + $o[$io + 1]] = $shapeIndex);

# Input and output: {grid}
# If the placement is feasible, call placeOrientation/3
def tryPlaceOrientation($o; $r; $c; $shapeIndex):
  .grid as $grid
  | if any( range(0; $o|length; 2);
         . as $io
         | ($c + $o[$io + 1]) as $x
         | ($r + $o[$io] ) as $y
         | $x < 0 or $x >= nCols or $y < 0 or $y >= nRows or $grid[$y][$x] != -1 )
    then empty
    else placeOrientation($o; $r; $c; $shapeIndex)
  end
  ;

# Input: {grid, placed, shapes}
def solve($pos; $numPlaced):
  if $numPlaced == (.shapes|length)
  then .
  else (($pos / nCols)|floor) as $row
  | ($pos % nCols ) as $col
  | if .grid[$row][$col] != -1
    then solve($pos + 1; $numPlaced)
    else .emit = false
    | foreach range(0; .shapes|length) as $i (.;
         if .placed[$i] then .
         else foreach .shapes[$i][] as $orientation (.;
                (tryPlaceOrientation($orientation; $row; $col; $i)
                 | .placed[$i] = true
                 | solve($pos + 1; $numPlaced + 1)
                 | .emit = true)
               // .)
         end )
     | select(.emit)
    end
  end;

# input: {shapes, symbols}
def shuffleShapes:
  (.shapes|length) as $n
  | reduce range(0; $n) as $i (.;
      ($n | prn) as $r
      | .shapes |= array_swap($r; $i)
      | .symbols |= array_swap($r; $i) )
;

def task:
  def grid:
    0 | array(nCols) | array(nRows);
  def placed:
    false | array(symbols|length - 1);

  { shapes: shapes,
    symbols: symbols,
    grid: grid,
    placed: placed}
  | shuffleShapes
  | reduce range(0; nRows) as $r (.;
      reduce range(0; .grid[$r]|length) as $c (.;
         .grid[$r][$c] = -1))
  | reduce range(0; 4) as $i (.;
      .done = false
      | until(.done;
            .randRow = (nRows | prn)
          | .randCol = (nCols | prn)
          | .done = (.grid[.randRow][.randCol] != blank) )
      | .grid[.randRow][.randCol] = blank
    )
  | first(solve(0; 0))
  | printResult
  // "No solution"
;
task
