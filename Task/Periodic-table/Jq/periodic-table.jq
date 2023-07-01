def limits: [[3,10], [11,18], [19,36], [37,54], [55,86], [87,118]];

def periodicTable(n):
  if (n < 1 or n > 118) then "Atomic number is out of range." | error
  elif n == 1 then [1, 1]
  elif n == 2 then [1, 18]
  elif (n >= 57 and n <= 71) then [8, n - 53]
  elif (n >= 89 and n <= 103) then [9, n - 85]
  else
  first( range( 0; limits|length) as $i
         | limits[$i] as $limit
         | if (n >= $limit[0] and n <= $limit[1])
           then {row: ($i + 2),
                 start: $limit[0],
                 end: $limit[1] }
           else empty
           end)
  | if (n < .start + 2 or .row == 4 or .row == 5)
    then [.row, n - .start + 1]
    else [.row, n - .end + 18]
    end
  end;

def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

(1, 2, 29, 42, 57, 58, 59, 71, 72, 89, 90, 103, 113) as $n
| periodicTable($n) as [$r, $c]
| "Atomic number \($n|lpad(3)) -> \($r) \($c)"
