# Tolerance
def eps: 1e-14;

# Output: a string
def intersects($p1; $p2; $cp; $r; $segment):

  {res: [], bnz: true}
  | $cp.x as $x0
  | $cp.y   as $y0
  | $p1.x   as $x1
  | $p1.y   as $y1
  | $p2.x   as $x2
  | $p2.y   as $y2
  | ($y2 - $y1) as $A
  | ($x1 - $x2) as $B
  | ($x2 * $y1 - $x1 * $y2)  as $C
  | ($A * $A + $B * $B) as $a

  | def within($x0; $y0):
        ((($x2 - $x1)*($x2 - $x1) + ($y2 - $y1)*($y2 - $y1)) |sqrt) as $d1  # distance between end-points
      | ((($x0 - $x1)*($x0 - $x1) + ($y0 - $y1)*($y0 - $y1)) |sqrt) as $d2  # distance from point to one end
      | ((($x2 - $x0)*($x2 - $x0) + ($y2 - $y0)*($y2 - $y0)) |sqrt) as $d3  # distance from point to other end
      | ($d1 - $d2 - $d3) as $delta
      | ($delta|length) < eps # true if delta is less than a small tolerance
    ;

    def rxy:
      if ($segment|not) or within(.x; .y)
      then .res += [{x, y}]
      end;

    def fx: -($A * .x + $C) / $B;
    def fy: -($B * .y + $C) / $A;

    if ($B|length) >= eps
    then
        .b = 2 * ($A * $C + $A * $B * $y0 - $B * $B * $x0)
      | .c = $C * $C + 2 * $B * $C * $y0 - $B * $B * ($r * $r - $x0 * $x0 - $y0 * $y0)
    else
        .b = 2 * ($B * $C + $A * $B * $x0 - $A * $A * $y0)
      | .c = $C * $C + 2 * $A * $C * $x0 - $A * $A * ($r * $r - $x0 * $x0 - $y0 * $y0)
      | .bnz = false
    end
  | (.b * .b - 4 * $a * .c) as $d # discriminant
  | if $d < 0
    then "[]"  # a string

    else
    # checks whether a point is within a segment
    .x = 0
    | .y = 0
    | if $d == 0
      then # line is tangent to circle, so just one intersect at most
        if .bnz
        then .x = -.b / (2 * $a)
           | .y = fx
        else
             .y = -.b / (2 * $a)
           | .x = fy
        end
        | rxy
      else # two intersections at most
        ($d|sqrt) as $D
        | if .bnz
          then .x = (-.b + $D) / (2 * $a)
             | .y = fx
             | rxy
             | .x = (-.b - $D) / (2 * $a)
             | .y = fx
             | rxy
          else .y = (-.b + $D) / (2 * $a)
             | .x = fy
             | rxy
             | .y = (-.b - $D) / (2 * $a)
             | .x = fy
             | rxy
          end
      end
    # avoid negative zeros
    | .res
    | tostring
    | gsub("-0,"; "0,") | gsub("-0}"; "0}")
    end
;


def task:

  ({cp: {x:3, y:-5},
     r: 3 }
   | "The intersection points (if any) between:",
     "  A circle, center \(.cp) with radius \(.r), and:",

     (  .p1 = {x: -10, y: 11}
      | .p2 = {x:  10, y: -9}
      | "    a line containing the points \(.p1) and \(.p2) is/are:",
        "     \(intersects(.p1; .p2; .cp; .r; false))" ),

     (  .p1 = {x: -10, y: 11}
      | .p2 = {x: -10, y:12}
      | "    a segment starting at \(.p1) and ending at \(.p2) is/are:",
        "     \(intersects(.p1; .p2; .cp; .r; true))"),

     (  .p1 = {x:3, y: -2}
      | .p2 = {x:7, y: -2}
      | "    a horizontal line containing the points \(.p1) and \(.p2) is/are:",
        "     \(intersects(.p1; .p2; .cp; .r; false))" ) ),

  ({cp: {x:0, y:0},
     r: 4 }
   | "  A circle, center \(.cp) with radius \(.r), and:",
     (  .p1 = {x:0, y:-3}
      | .p2 = {x:0, y: 6}
      | "    a vertical line containing the points \(.p1) and \(.p2) is/are:",
        "     \(intersects(.p1; .p2; .cp; .r; false))",
        "    a vertical segment containing the points \(.p1) and \(.p2) is/are:",
        "     \(intersects(.p1; .p2; .cp; .r; true))") ),

  ({cp: {x:4, y: 2},
     r: 5 }
   | "  A circle, center \(.cp) with radius \(.r), and:",

     (  .p1 = {x: 6, y: 3}
      | .p2 = {x:10, y: 7}
      | "    a line containing the points \(.p1) and \(.p2) is/are:",
      "     \(intersects(.p1; .p2; .cp; .r; false))"),

     (  .p1 = {x: 7, y: 4}
      | .p2 = {x:11, y: 8}
      | "    a segment starting at \(.p1) and ending at \(.p2) is/are:",
      "     \(intersects(.p1; .p2; .cp; .r; true))") ),

  ({cp: {x:10, y: 10},
     r:  5 }
   | "  A circle, center \(.cp) with radius \(.r), and:",

    (  .p1 = {x: 5,  y: 0}
     | .p2 = {x: 5, y: 20}
     | "    a vertical line containing the points \(.p1) and \(.p2) is/are:",
       "     \(intersects(.p1; .p2; .cp; .r; false))"),

    (  .p1 = {x:-5, y: 10}
     | .p2 = {x: 5, y: 10}
     | "    a horizontal segment starting at \(.p1) and ending at \(.p2) is/are:",
       "     \(intersects(.p1; .p2; .cp; .r; true))") )
;

task
