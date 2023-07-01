[limit(10; sylvester)]
| "First 10 Sylvester numbers:",
  (range(0;10) as $i | "\($i+1|lpad) => \(.[$i])"),
  "",
  "Sum of reciprocals of first 10 is approximately: \(map( 1/ .) | add)"
