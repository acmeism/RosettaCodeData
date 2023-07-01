# If using gojq, one may want to preserve integer precision, so:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

{ prod: 1,                             #  start with a product of unity.
  sum:  0,                             #  henceforth skip redundant comments.
    x:  5,
    y: -5,
    z: -2,
  one:  1,
  three: 3,
  seven: 7 }
| .x as $x
| reduce (range(-.three; 1 + 3|power(3); .three),
          range(-.seven; 1 + .seven;     .x),
          range(    555; 1 +  550 - .y),
          range(     22; -1 -28;          -.three),
          range(1927   ; 1 + 1939),
          range(.x     ; .y;              .z),
          range(11|power($x); 1 + ( 11 | power($x)) + .one)) as $j (.;
             .sum += ($j|length)                         # add absolute value of $j (!)
             | if (.prod|length) < (2|power(27)) and $j != 0
	       then .prod *= $j
	       else .
	       end )
| "sum=  \(.sum)",
  "prod= \(.prod)"
