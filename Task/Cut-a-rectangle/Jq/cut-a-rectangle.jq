def dir: [[0, -1], [-1, 0], [0, 1], [1, 0]] ;

# input and output: {grid, w, h, len, count, next}
def mywalk($y; $x):
  if ($y == 0 or $y == .h or $x == 0 or $x == .w)
  then .count += 2
  else ($y * (.w + 1) + $x) as $t
  | .grid[$t] += 1
  | .grid[.len-$t] += 1
  | reduce range(0; 4) as $i (.;
      if .grid[$t + .next[$i]] == 0
      then mywalk($y + dir[$i][0]; $x + dir[$i][1])
      else .
      end )
  | .grid[$t] += -1
  | .grid[.len-$t] += -1
  end;

# solve/3 returns an integer.
# If $count is null, the value is the count of permissible cuts for an $h x $w rectangle.
# Otherwise, the computed value augments $count.
def solve($h; $w; $count):
  if $count then {$count} else {} end
  | if $h % 2 == 0
    then . + {$h, $w}
    else . + {w: $h, h: $w}  # swap
    end
  | if (.h % 2 == 1) then 0
    elif (.w == 1)   then 1
    elif (.w == 2)   then .h
    elif (.h == 2)   then .w
    else ((.h/2)|floor) as $cy
    | ((.w/2)|floor) as $cx
    | .len = (.h + 1) * (.w + 1)
    | .grid = [range(0; .len) | 0]
    | .len += -1
    | .next = [-1, - .w - 1, 1, .w + 1]
    | .x = $cx + 1
    | until (.x >= .w;
        ($cy * (.w + 1) + .x) as $t
        | .grid[$t] = 1
        | .grid[.len-$t] = 1
        | mywalk($cy - 1; .x)
        | .x += 1 )
    | .count += 1
    | if .h == .w
      then .count * 2
      elif (.w % 2 == 0) and $count == null
      then solve(.w; .h; .count)
      else .count
      end
    end ;

def task($n):
  range (1; $n+1) as $y
  | range(1; $y + 1) as $x
  | select(($x % 2 == 0) or ($y % 2 == 0))
  | "\($y) x \($x) : \(solve($y; $x; null))" ;

task(10)
