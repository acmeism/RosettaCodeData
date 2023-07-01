def stoogesort:
  def swap(i;j): .[i] as $t | .[i] = .[j] | .[j] = $t;

  # for efficiency, define an auxiliary function
  # that takes as input [L, i, j]
  def ss: .[1] as $i | .[2] as $j
     | .[0]
     | if .[$j] < .[$i] then swap($i;$j) else . end
     | if $j - $i > 1 then
          (($j - $i + 1) / 3 | floor) as $t
          | [., $i, $j-$t] | ss
	  | [., $i+$t, $j] | ss
	  | [., $i, $j-$t] | ss
       else .
       end;

  [., 0, length-1] | ss;
