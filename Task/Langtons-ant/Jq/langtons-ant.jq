def matrix(m; n; init):
  if m == 0 then [range(0;n)] | map(init)
  elif m > 0 then [range(0;m)][ range(0;m) ] = matrix(0;n;init)
  else error("matrix\(m);_;_) invalid")
  end;

def printout:
  . as $grid
  | ($grid|length) as $height
  | ($grid[0]|length) as $width
  | reduce range(0;$height) as $i ("\u001B[H"; # ANSI code
    . + reduce range(0;$width) as $j ("\n";
         . + if $grid[$i][$j] then " " else "#" end ) );


def langtons_ant(grid_size):

  def flip(ant):
    # Flip the color of the current square
    .[ant[0]][ant[1]] = (.[ant[0]][ant[1]] | not)
  ;

  # input/output: the ant's state: [x, y, direction]
  # where direction is one of (0,1,2,3)
  def move(grid):
    # If the cell is black, it changes to white and the ant turns left;
    # If the cell is white, it changes to black and the ant turns right;
    (if grid[.[0]][.[1]] then 1 else 3 end) as $turn
    | .[2] = ((.[2] + $turn) % 4)
    | if   .[2] == 0 then .[0] += 1
      elif .[2] == 1 then .[1] += 1
      elif .[2] == 2 then .[0] += -1
      else                .[1] += -1
      end
  ;

  # state: [ant, grid]
  def iterate:
    .[0] as $ant | .[1] as $grid
    # exit if the ant is outside the grid
    | if $ant[0] < 1 or $ant[0] > grid_size
      or $ant[1] < 1 or $ant[1] > grid_size
      then [ $ant, $grid ]
      else
        ($grid | flip($ant)) as $grid
        | ($ant | move($grid)) as $ant
        | [$ant, $grid] | iterate
      end
  ;

  ((grid_size/2) | floor | [ ., ., 0]) as $ant
  | matrix(grid_size; grid_size; true) as $grid
  | [$ant, $grid] | iterate
  | .[1]
  | printout
;

langtons_ant(100)
