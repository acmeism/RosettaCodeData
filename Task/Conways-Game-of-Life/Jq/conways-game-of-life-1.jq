# Notes on the implementation:

# 1. For efficiency, the implementation requires that the world
#    has boundaries, as illustrated in the examples.
# 2. For speed, the simulation uses the exploded string.
# 3. The ASCII values of the "alive" and "empty" symbols are
#    hardcoded: "." => 46; " " => 32
# 4. To adjust the refresh rate, adjust the input to "spin".

def lines: split("\n")|length;

def cols: split("\n")[0]|length + 1;  # allow for the newline

# Is there a "." (46) at [x,y] relative to position i,
# assuming the width is w?
# Input is an array; result is 0 or 1 so we can easily count the total.
def isAlive(x; y; i; w): if .[i+ w*y + x] == 46 then 1 else 0 end;

def neighborhood(i;w):
  isAlive(-1; -1; i; w) + isAlive(0; -1; i; w) + isAlive(1; -1; i; w) +
  isAlive(-1;  0; i; w)                        + isAlive(1;  0; i; w) +
  isAlive(-1;  1; i; w) + isAlive(0;  1; i; w) + isAlive(1;  1; i; w) ;

# The basic rules:
def evolve(cell; sum) :
  if   cell == 46 then if sum == 2 or sum == 3 then 46 else 32 end
  elif cell == 32 then if sum == 3 then 46 else 32 end
  else cell
  end ;

# [world, lines, cols] | next(w) => [world, lines, cols]
def next:
  .[0] as $world | .[1] as $lines | .[2] as $w
  | reduce range(0; $world|length) as $i
    ($world;
      .[$i] as $c
      | if $c == 32 or $c == 46 then
           # updates are "simultaneous" i.e. relative to $world, not "."
           ($world | neighborhood($i; $w)) as $sum
           | evolve($c; $sum) as $next
           | if $c == $next then . else .[$i] = $next end
        else .
        end )
  | [., $lines, $w] ;
