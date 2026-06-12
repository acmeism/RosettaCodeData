def sqrt_by_hand($limit):
  . as $n
  | if $n < 0 then "sqrt_by_hand: input cannot be negative." | error
    else {count: 0, $n}
    | until( .n | . == floor;
        .n *= 100
        | .count += -1 )
    | .i = (.n|tostring|tonumber) # ensure .i is an integer
    | .j = (.i|isqrt)
    | .count = (.count + (.j|tostring|length))
    | .k = .j
    | .d = .j
    | .digits = 0
    | .root = ""
    | until (.digits >= $limit;
        .root = (.root + (.d|tostring))
        | .i = ((.i - .k*.d) * 100)
        | .k = (.j * 20)
        | .d = 1
	| .stop = false
        | until ((.d > 10) or .stop;
            if (.k + .d)*.d > .i
            then .d += -1
            | .stop = true
	    else .d += 1
	    end )
        | .j = (.j*10 + .d)
        | .k = (.k + .d)
        | .digits += 1 )
    | .root |= sub("0+$"; "")
    | if .root == "" then .root = "0" else . end
    | if .count > 0
      then .root = .root[0:.count] + "." + .root[.count:]
      elif .count == 0
      then .root = "0." + .root
      else .root = "0." + ("0" * (-.count)) + .root
      end
    | if .root[-1:] == "."
      then .root |= .[:-1]
      else .
      end
    | .root
    end ;

[2, 0.2, 10.89, 625, 0.0001] as $numbers
| [500, 80, 8, 8, 8] as $digits
| range (0; $numbers|length) as $i
| $numbers[$i]
| "First \($digits[$i]) significant digits (at most) of the square root of \(.):",
   sqrt_by_hand($digits[$i]),
   ""
