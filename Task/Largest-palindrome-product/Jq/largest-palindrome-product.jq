def reverseNumber:
  tostring|explode|reverse|implode|tonumber;

def task:
  { pow: 10}
  | foreach range(2;8) as $n (.;
      (.pow * 9) as $low
      | .pow *= 10
      | (.pow - 1) as $high
      | .emit = null
      | .nextN = false
      | label $out
      | foreach range($high; $low - 1; -1) as $i (.;
          ($i|reverseNumber) as $j
          | ($i * .pow + $j) as $p
          # k can't be even nor end in 5 to produce a product ending in 9
          | .k = $high
	  | .done = false
          | until(.k <= $low or .done;
              if (.k % 10 != 5)
              then ($p / .k) as $l
              | if $l > $high
	        then .done = true
                elif $p % .k == 0
                then .emit = "Largest palindromic product of two \($n)-digit integers: \(.k) x \($l) = \($p)"
                | .nextN = true
                | .done = true
                else .
		end
	      else .
  	      end
              | .k += -2 )
          | if .nextN then ., break $out else . end;
	  select(.emit) );
    .emit ) ;

task
