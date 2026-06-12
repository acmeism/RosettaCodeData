def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def printMinCells:
  "Minimum number of cells after, before, above and below each cell in a \(.) x \(.) matrix:",
  ( (. / 2 | ceil | tostring | length) as $p
    | range(0; .) as $r
    | [ range(0; .) as $c
        | [. - $r - 1, $r, $c, . - $c - 1] | min | lpad($p)] | join(" ") );

23, 10, 9, 2, 1
|  printMinCells, ""
