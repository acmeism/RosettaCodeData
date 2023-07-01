def task1($limit):
  [limit($limit; arithmetic_numbers)] | _nwise(10) | map(lpad(4)) | join(" ");

# $points should be a stream of integers, in order, specifying the reporting points
def task2($points):
  last($points) as $last
  | label $out
  | foreach arithmetic_numbers as $n ({count:0};
      .count += 1
      | if $n | composite  then .composite += 1 else . end;
      (select( .count | IN( $points) ) | .n = $n),
      if .count == $last then break $out else empty end );

task1(100),
"",
(task2( 1000, 10000, 100000, 1000000 )
 | "The \(.count)th arithmetic number is \(.n);",
   "there are \(.composite) composite arithmetic numbers up to \(.n).\n")
