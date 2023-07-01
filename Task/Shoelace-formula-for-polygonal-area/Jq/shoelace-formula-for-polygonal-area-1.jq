# jq's length applied to a number is its absolute value.
def shoelace:
  . as $a
  | reduce range(0; length-1) as $i (0;
      . + $a[$i][0]*$a[$i+1][1] - $a[$i+1][0]*$a[$i][1] )
  | (. + $a[-1][0]*$a[0][1] - $a[0][0]*$a[-1][1])|length / 2;

[ [3, 4], [5, 11], [12, 8], [9, 5], [5, 6] ]
| "The polygon with vertices at \(.) has an area of \(shoelace)."
