def isCusip:
  length == 9 and
  explode as $s
  | {sum: 0, i: 0}
  | until(. == false or .i == 8;
      $s[.i] as $c
      | (if ($c >= 48 and $c <= 57)    # '0' to '9'
         then $c - 48
         elif ($c >= 65 and $c <= 90)  # 'A' to 'Z'
         then $c - 55
         elif $c == 42                 # '*'
         then 36
         elif $c == 64                 # '@'
         then 37
         elif $c == 35                 # '#'
         then 38
         else false                    # return false
         end ) as $v
      | if $v == false then false
        else # check if odd as using 0-based indexing
            (if (.i%2 == 1) then 2 * $v else $v end) as $v
        | .sum += (($v/10)|floor) + $v%10
        | .i += 1
        end )
  | if . == false then false
    else $s[8] - 48 == (10 - (.sum%10)) % 10
    end;

def candidates: [
    "037833100",
    "17275R102",
    "38259P508",
    "594918104",
    "68389X106",
    "68389X105"
];

candidates[]
| "\(.) -> \(if isCusip then "correct" else "incorrect" end)"
