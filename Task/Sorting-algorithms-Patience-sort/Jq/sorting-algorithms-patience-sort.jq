def patienceSort:
  length as $size
  | if $size < 2 then .
    else
      reduce .[] as $e ( {piles: []};
        .outer = false
	| first( range(0; .piles|length) as $ipile
                 | if .piles[$ipile][-1] < $e
                   then .piles[$ipile] += [$e]
                   | .outer = true
		   else empty
		   end ) // .
        | if (.outer|not) then .piles += [[$e]] else . end )
    | reduce range(0; $size) as $i (.;
        .min = .piles[0][0]
        | .minPileIndex = 0
        | reduce range(1; .piles|length) as $j (.;
            if .piles[$j][0] < .min
            then .min = .piles[$j][0]
            | .minPileIndex = $j
	    else .
	    end )
        | .a += [.min]
	| .minPileIndex as $mpx
	| .piles[$mpx] |= .[1:]
        | if (.piles[$mpx] == []) then .piles |= .[:$mpx] + .[$mpx + 1:]
	  else .
	  end)
  end
  | .a ;


[4, 65, 2, -31, 0, 99, 83, 782, 1],
 ["n", "o", "n", "z", "e", "r", "o", "s", "u", "m"],
 ["dog", "cow", "cat", "ape", "ant", "man", "pig", "ass", "gnu"]
| patienceSort
