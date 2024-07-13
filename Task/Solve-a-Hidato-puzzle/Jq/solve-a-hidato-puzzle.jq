### Generic functions

def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

### Hidato Puzzle

# "." ~ -1 (dead cell)
# "_" ~  0 (to be assigned a number)
def printBoard:
  .board[] as $row
  | reduce $row[] as $c ("";
      if $c == -1 then . + " . "
      elif $c > 0 then . + ($c | lpad(3))
      else . + " __"
      end);

# output: { board, given, start}
# "." signifies a dead cell
def setUp($in):
  { board:[], given:[], start:[] }
  | ($in|length) as $nRows
  | [range(0;$nRows) | ($in[.]|split(" "))] as $puzzle
  | ($puzzle[0]|length) as $nCols
  | .board = [range(0; $nRows+2) | null]
  | reduce range(0; .board|length) as $i (. ; .board[$i] = [range(0; $nCols+2) | -1])
  | reduce range(0; $nRows) as $r (.;
       $puzzle[$r] as $row
       | reduce range(0; $nCols) as $c (.;
            $row[$c] as $cell
            | if $cell == "_"
              then .board[$r + 1][$c + 1] = 0
              elif $cell != "."
              then ($cell | tonumber) as $value
              | .board[$r + 1][$c + 1] = $value
              | .given += [$value]
              | if $value == 1 then .start = [$r + 1, $c + 1] end
              end ))
  | .given |= sort ;

# Generate all solutions, that is, emit empty on failure.
# $r is a row, $c is a column, $n is the number we're looking for,
# $next is the index in .given of the next given number.
def solve($r; $c; $n; $next):
  if $n > .given[-1] then .         # all done
  else .board[$r][$c] as $back
  | if ($back != 0 and $back != $n) then empty
    elif $back == 0 and .given[$next] == $n then empty
    else
      (if $back == $n then (1+$next) else $next end) as $next2
    | if $n != $back then .board[$r][$c] = $n end   # avoid unnecessary copying
    | (  (-1, 0, 1) as $i
       | (-1, 0, 1) as $j
       | solve($r + $i; $c + $j; $n + 1; $next2)
       )
    end
  end;


def example: [
    "_ 33 35 _ _ . . .",
    "_ _ 24 22 _ . . .",
    "_ _ _ 21 _ _ . .",
    "_ 26 _ 13 40 11 . .",
    "27 _ _ _ 9 _ 1 .",
    ". . _ _ 18 _ _ .",
    ". . . . _ 7 _ _",
    ". . . . . . 5 _"
];

setUp(example)
| printBoard,
  "\nFound:",
  ( first( solve(.start[0]; .start[1]; 1; 0) )
    | printBoard)
