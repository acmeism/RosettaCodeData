def lpad($len): tostring | ($len - length) as $l | (" " * $l) + .;

def moves: [ [-1, -2], [1, -2], [-1, 2], [1, 2], [-2, -1], [-2, 1], [2, -1], [2, 1] ];

def board1:
    " xxx    " +
    " x xx   " +
    " xxxxxxx" +
    "xxx  x x" +
    "x x  xxx" +
    "sxxxxxx " +
    "  xx x  " +
    "   xxx  "
;
def board2:
    ".....s.x....." +
    ".....x.x....." +
    "....xxxxx...." +
    ".....xxx....." +
    "..x..x.x..x.." +
    "xxxxx...xxxxx" +
    "..xx.....xx.." +
    "xxxxx...xxxxx" +
    "..x..x.x..x.." +
    ".....xxx....." +
    "....xxxxx...." +
    ".....x.x....." +
    ".....x.x....."
;

# Input: {pz}
def solve($sz; $sx; $sy; $idx; $cnt):
  # debug( "solve(\($sz); \($sx); \($sy); \($idx); \($cnt))" ) |
  if $idx > $cnt then .
  else first(
    range(0;moves|length) as $i
      | ($sx + moves[$i][0]) as $x
      | ($sy + moves[$i][1]) as $y
      | if $x >= 0 and $x < $sz and $y >= 0 and $y < $sz and .pz[$x][$y] == 0
        then .pz[$x][$y] = $idx
        | solve($sz; $x; $y; $idx + 1; $cnt)
        else empty
        end )
  end;

def printSolution($sz):
  range(0; $sz) as $j
  |  .emit = ""
  | reduce range(0; $sz) as $i (.;
      if .pz[$i][$j] != -1
      then .emit += (.pz[$i][$j] | lpad(3))
      else .emit += " --"
      end )
  | .emit;

# $b should be a board of size $sz
def findSolution($b; $sz):
  [range(0; $sz) | -1] as $minus
  | { pz: [range(0;$sz) | $minus],
      x: 0,
      y: 0,
      idx: 0,
      cnt: 0
    }
  | reduce range(0; $sz) as $j (.;
      reduce range(0; $sz) as $i (.;
        if $b[.idx: .idx+1] == "x"
        then .pz[$i][$j] = 0
             | .cnt +=  1
        elif $b[.idx: .idx+1] == "s"
        then
             .pz[$i][$j] = 1
             | .cnt += 1
             | .x = $i
             | .y = $j
        end
        | .idx += 1 ))
  | (solve($sz; .x; .y; 2; .cnt) | printSolution($sz))
    // "Whoops!" ;

findSolution(board1;  8),
"",
findSolution(board2; 13)
