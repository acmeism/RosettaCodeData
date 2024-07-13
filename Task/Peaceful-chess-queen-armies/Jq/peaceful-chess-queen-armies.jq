# Is the queen at position . attacking the position $pos ?
def isAttacking($pos):
   .x == $pos.x or
   .y == $pos.y or
   (((.x - $pos.x)|length) == ((.y - $pos.y)|length)); # i.e. abs

# Place $q black and $q white queens on an $n*$n board,
# where .blackQueens holds the positions of existing black Queens,
# and similarly for .whiteQueens.
# input: {blackQueens, whiteQueens}
# output: updated input on success, otherwise null.
def place($queens; $n):
  def place($q):
    if $q == 0 then .ok = true
    else .placingBlack = true
    | first(
       foreach range(0; $n) as $i (.;
        foreach range(0; $n) as $j (.;
           {x:$i, y:$j} as $pos
           | .placingBlack as $placingBlack
           | if any( .blackQueens[], .whiteQueens[];
                      ((.x == $pos.x) and (.y == $pos.y)))
             then . # failure
             elif .placingBlack
             then if any( .whiteQueens[]; isAttacking($pos) )
                  then .
                  else .blackQueens += [$pos]
                  | .placingBlack = false
                  end
             elif any( .blackQueens[]; isAttacking($pos) )
             then .
             else .whiteQueens += [$pos]
             | place($q-1) as $place
             | if $place then $place  # success
               else .blackQueens |= .[:-1]
               | .whiteQueens |= .[:-1]
               | .placingBlack = true
               end
             end
           | if $i == $n-1 and $j == $n-1 then .ok = false end );
        select(.ok) )
      ) // null
    end;
  {blackQueens: [], whiteQueens: [] } | place($queens);

# Input {blackQueens, whiteQueens}
def printBoard($n):
  [range(0; $n) | 0] as $row
  | .board = [range(0; $n) | $row]
  | reduce .blackQueens[] as $queen (.; .board[$queen.x][$queen.y] = "B ")
  | reduce .whiteQueens[] as $queen (.; .board[$queen.x][$queen.y] = "W ")
  | foreach range(0; $n) as $i (.;
      reduce range(0; $n) as $j (.row="";
        .board[$i][$j] as $b
        | .row +=
             (if $b != 0 then $b
              elif $i%2 == $j%2
              then "• "
              else "◦ "
              end) ) )
  | .row;

# Use an object {squares, queens} to record the task:
# $squares is the number of squares on each side of the board,
# and $queens is the number of queens of each color.
def Task($squares; $queens): {$squares, $queens};

def tasks: [
    Task(2; 1), Task(3; 1), Task(3; 2), Task(4; 1), Task(4; 2), Task(4; 3),
    Task(5; 1), Task(5; 2), Task(5; 3), Task(5; 4), Task(5; 5),
    Task(6; 1), Task(6; 2), Task(6; 3), Task(6; 4), Task(6; 5), Task(6; 6),
    Task(7; 1), Task(7; 2), Task(7; 3), Task(7; 4), Task(7; 5), Task(7; 6), Task(7; 7)
];

tasks[] as $t
| "\($t.queens) black and \($t.queens) white queens on a \($t.squares) x \($t.squares) board:",
  ((place($t.queens; $t.squares)
   | select(.)
   | printBoard($t.squares))
   // "No solution exists."),
   ""
