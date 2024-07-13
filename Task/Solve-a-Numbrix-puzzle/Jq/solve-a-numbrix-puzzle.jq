def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def moves: [ [1, 0], [0, 1], [-1, 0], [0, -1] ];

# "All solutions"
# Can the puzzle be solved by placing the token $count at row $r, column $c?
# Input: { grid, clues, totalToFill }
def solve($r; $c; $count; $nextClue):
  if $count > .totalToFill then .
  else .grid[$r][$c] as $back
  | if ($back != 0 and $back != $count)
        or ($back == 0 and $nextClue < (.clues|length) and .clues[$nextClue] == $count)
    then empty
    else if $back == $count then .nextClue += 1 end
    | .grid[$r][$c] = $count
    | moves[] as $m
    | solve($r + $m[1]; $c + $m[0]; $count + 1; $nextClue)
    end
  end ;

def printResult:
  .grid[1:-1][] as $row
  | reduce range(1; $row|length -1) as $i ("";
      . + (if $i != -1 then $row[$i] else "" end | lpad(3)) );

def task($board):
  { clues: [] }
  | (($board|length) + 2) as $nRows
  | ($board[0]|split(",")|length + 2) as $nCols
  | .startRow = 0
  | .startCol = 0
  | [range(0; $nCols) | -1] as $m1
  | .grid = [range(0; $nRows) | $m1]
  | .totalToFill = ($nRows - 2) * ($nCols - 2)
  | reduce range(0; $nRows) as $r (.;
      if $r >= 1 and $r < $nRows - 1
      then ($board[$r - 1]|split(",")) as $row
      | reduce range(1; $nCols - 1) as $c (.;
          ($row[$c - 1] | sub("^0";"") | tonumber) as $value
          | if $value > 0 then .clues += [$value] end
          | if $value == 1
            then .startRow = $r
            | .startCol = $c
            end
          | .grid[$r][$c] = $value )
      end )
  | .clues |= sort
  | .startRow as $startRow
  | .startCol as $startCol
  | first(solve($startRow; $startCol; 1; 0))
  | printResult ;

### Examples

def example1: [
    "00,00,00,00,00,00,00,00,00",
    "00,00,46,45,00,55,74,00,00",
    "00,38,00,00,43,00,00,78,00",
    "00,35,00,00,00,00,00,71,00",
    "00,00,33,00,00,00,59,00,00",
    "00,17,00,00,00,00,00,67,00",
    "00,18,00,00,11,00,00,64,00",
    "00,00,24,21,00,01,02,00,00",
    "00,00,00,00,00,00,00,00,00"
];

def example2: [
    "00,00,00,00,00,00,00,00,00",
    "00,11,12,15,18,21,62,61,00",
    "00,06,00,00,00,00,00,60,00",
    "00,33,00,00,00,00,00,57,00",
    "00,32,00,00,00,00,00,56,00",
    "00,37,00,01,00,00,00,73,00",
    "00,38,00,00,00,00,00,72,00",
    "00,43,44,47,48,51,76,77,00",
    "00,00,00,00,00,00,00,00,00"
];

  "Example 1", task(example1),
"\nExample 2", task(example2)
