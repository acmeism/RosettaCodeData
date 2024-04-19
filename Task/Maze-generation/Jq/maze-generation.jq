# Output: a prn in range(0;$n) where $n is .
def prn:
  if . == 1 then 0
  else . as $n
  | (($n-1)|tostring|length) as $w
  | [limit($w; inputs)] | join("") | tonumber
  | if . < $n then . else ($n | prn) end
  end;

# Input: an array
def knuthShuffle:
  length as $n
  | if $n <= 1 then .
    else {i: $n, a: .}
    | until(.i ==  0;
        .i += -1
        | (.i + 1 | prn) as $j
        | .a[.i] as $t
        | .a[.i] = .a[$j]
        | .a[$j] = $t)
    | .a
    end;

# Compass is a JSON object {n,s,e,w} representing the four possible
# directions in which to move, i.e. to open a gate.
# For example, Compass.n corresponds to a move north (i.e. dx is 0, dy is 1),
# and Compass.n.gates["N"] is true indicating that the "northern" gate should be opened.
def Compass:
  {n: { gates: {"N": true},  dx: 0, dy: -1},
   s: { gates: {"S": true},  dx: 0, dy:  1},
   e: { gates: {"E": true},  dx: 1, dy:  0},
   w: { gates: {"W": true},  dx:-1, dy:  0} }
  | .n.opposite = .s
  | .s.opposite = .n
  | .e.opposite = .w
  | .w.opposite = .e
;

# Produce a matrix representing an $x x $y maze.
# .[$i][$j] represents the box in row $i, column $j.
# Initially, all the gates of all the boxes are closed.
def MazeMatrix($x; $y):
  [range(0;$x) | {} ] as $v | [range(0;$y) | $v];

# Input: a MazeMatrix
def generate($cx; $cy):
  def interior($a; $upper): $a >= 0 and $a < $upper;
  length as $x
  | (.[0]|length) as $y
  | Compass as $Compass
  | ([$Compass.n, $Compass.s, $Compass.e, $Compass.w] | knuthShuffle) as $directions
  | reduce $directions[] as $v (.;
      ($cx + $v.dx) as $nx
      | ($cy + $v.dy) as $ny
      |  if interior($nx; $x) and interior($ny; $y) and .[$nx][$ny] == {}
         then .[$cx][$cy] += $v.gates
            | .[$nx][$ny] += $v.opposite.gates
            | generate($nx; $ny)
         end );

# Input: a MazeMatrix
def display:
  . as $maze
  | ($maze|length) as $x
  | ($maze[0]|length) as $y
  | ( range(0;$y) as $i
      # draw the north edge
      | ([range(0;$x) as $j
         | if $maze[$j][$i]["N"] then "+   " else "+---" end] | join("")) +  "+",
      # draw the west edge
        ([range(0;$x) as $j
         | if $maze[$j][$i]["W"] then "    " else "|   " end] | join(""))   + "|" ),
    # draw the bottom line
   ($x * "+---") + "+"
;

# Start the walk at the top left
def amaze($x;$y):
  MazeMatrix($x; $y)
  | generate(0; 0)
  | display;

# Example
amaze(4; 5);
