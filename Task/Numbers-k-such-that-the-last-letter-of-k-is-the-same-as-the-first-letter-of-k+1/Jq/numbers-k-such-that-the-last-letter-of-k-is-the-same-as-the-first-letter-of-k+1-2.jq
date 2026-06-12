def task($limit):
  [range(0;10) | tostring] as $labels
  | {i:      0,
     c:      0,
     nums:   [],
     lastDigs: [range(0;10)|0],
     prev:   "zero",
     limit:  1000 }
  | whilst (.limit <= $limit;
      .emit = null
      |  (.i+1 | number2name) as $next
      | if .prev[-1:] == $next[:1]
        then if (.c < 50) then .nums += [.i] else . end
        | .lastDigs[.i % 10] += 1
        | .c += 1
        | if .c == 50
          then .emit = ["First 50 numbers:", (.nums|tprint(10;3))]
          elif .c == .limit
          then .emit = ["\nThe \(.c)th number is \(.i)\n"]
          | "Breakdown by last digit of first \(.c) numbers" as $title
          | .emit += [barChart($title; 80; $labels; .lastDigs)]
          | .limit *= 10
          else .
          end
        else .
        end
      | .prev = $next
      | .i += 1 )
  | select(.emit).emit[] ;

task(1e6)
