# For gojq:
def power($b): . as $in | reduce range(0;$b) as $i (1; . * $in);

def endsWithOne:
  . as $start
  | { n: ., sum: 0 }
  | until(.stop;
        until(.n <= 0;
             (.n % 10) as $digit
            | .sum +=  $digit * $digit
            | .n = (.n / 10 | floor)
        )
        | if .sum == 1 then .stop = 1
          elif .sum == 89 then .stop = 0
	  else .n = .sum
	  | .sum = 0
	  end )
  | .stop == 1 ;

def ks: [7, 8, 11, 14, 17];

ks[] as $k
| {sums: [1,0]}
| reduce range(1; $k+1) as $n (.;
        reduce range( $n*81; 0; -1) as $i (.;
    	    .emit = false
	    | .j = 0
            | until(.emit or (.j == 9);
	        .j+=1
                | (.j * .j) as $s
                | if ($s > $i) then .emit = true
                  else .sums[$i] = .sums[$i] + .sums[$i-$s]
                  end) ))
| .count1 = 0
| reduce range(1; 1 + $k*81) as $i (.; if $i|endsWithOne then .count1 = .count1 + .sums[$i] else . end)
| ((10|power($k)) - 1) as $limit
| "For k = \($k) in the range 1 to \($limit)",
  "\(.count1) numbers produce 1 and \($limit - .count1) numbers produce 89.\n"
