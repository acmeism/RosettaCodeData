# The number of columns
def boardSize: 8;

# {x,y} with .x >= 0 and .y >= 0
def Square($x; $y): {$x, $y};

# Input: a Square assuming .x <= 25
def notate:
  .x as $x
  | "abcdefghijklmnopqrstuvwxyz"[$x:$x+1] + "\(.y + 1)";

# Input: a Square
# Output: a stream of possible Squares reachable from .
def knightMoves:
  def axisMoves: [1, 2, -1, -2];

  # Is the input Square on the board?
  def onBoard:
    0 <= .x and .x < boardSize and 0 <= .y and .y < boardSize;

  . as $s
  | axisMoves
  | combinations(2)
  | select( (.[0]|length) != (.[1]|length) )  # abs
  | Square($s.x + .[0]; $s.y + .[1])
  | select(onBoard) ;

# $moves should be a non-empty array specifying an initial fragment of a possible tour
def knightTour($moves):
  # Find the array of relevant possible one-step moves from the Square specified by .
  def findMoves:
    [ knightMoves | select( IN($moves[]) | not) ] ;

  ($moves[-1] | findMoves) as $fm
  | if $fm == [] then $moves
    else ($fm | min_by( findMoves|length )) as $next
    | knightTour($moves + [$next])
    end ;

def knightTourFrom($start):
  knightTour([$start]) ;

def example($square):
  knightTourFrom($square)
  | (_nwise(boardSize) | map("\(.x),\(.y)") | join("  ")),
    "\nAlgebraic notation:",
    (_nwise(boardSize) | map( notate ) | join("  "))
  ;

example(Square(1; 1))
