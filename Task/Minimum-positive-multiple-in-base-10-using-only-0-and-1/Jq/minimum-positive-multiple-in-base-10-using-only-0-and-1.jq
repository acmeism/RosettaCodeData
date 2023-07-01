def lpad($len): tostring | ($len - length) as $l | (" " * $l)[:$l] + .;

def pp(a;b;c): "\(a|lpad(4)): \(b|lpad(28)) \(c|lpad(24))";

def b10:
  . as $n
  | if . == 1 then pp(1;1;1)
    else ($n + 1) as $n1
    | { pow: [range(0;$n)|0],
        val: [range(0;$n)|0],
        count: 0,
        ten: 1,
        x: 1 }
    | until (.x >= $n1;
        .val[.x] = .ten
        | reduce range(0;$n1) as $j (.;
            if .pow[$j] != 0 and .pow[($j+.ten)%$n] == 0 and .pow[$j] != .x
	    then .pow[($j+.ten)%$n] = .x
	    else . end )
        | if .pow[.ten] == 0 then .pow[.ten] = .x else . end
        | .ten = (10*.ten) % $n
        | if .pow[0] != 0 then .x = $n1  # .x will soon be reset
          else .x += 1
	  end )
    | .x = $n
    | if .pow[0] != 0
      then .s = ""
      | until (.x == 0;
          .pow[.x % $n] as $p
          | if .count > $p then .s += ("0" * (.count-$p)) else . end
          | .count = $p - 1
          | .s += "1"
          | .x = ( ($n + .x - .val[$p]) % $n ) )
      | if .count > 0 then .s += ("0" * .count) else . end
      | pp($n; .s; .s|tonumber/$n)
      else "Can't do it!"
      end
    end;

def tests: [
    [1, 10], [95, 105], [297], [576], [594], [891], [909], [999],
    [1998], [2079], [2251], [2277], [2439], [2997], [4878]
];

pp("n"; "B10"; "multiplier"),
(pp("-";"-";"-")  | gsub(".";"-")),
(  tests[]
   | .[0] as $from
   | (if length == 2 then .[1] else $from end) as $to
   | range($from; $to + 1)
   | b10 )
