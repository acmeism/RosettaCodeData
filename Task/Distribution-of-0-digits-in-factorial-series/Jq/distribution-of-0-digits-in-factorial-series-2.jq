def count(s): reduce s as $x (0; .+1);

def meanfactorialdigits:
   def digits: tostring | explode;
   def nzeros: count( .[] | select(. == 48) ); # "0" is 48

   . as $N
   | 0.16 as $goal
   | label $out
   | reduce range( 1; 1+$N ) as $i ( {factorial: "1", proportionsum: 0.0, first: null };
        .factorial = long_multiply(.factorial; $i|tostring)
        | (.factorial|digits) as $d
        | .proportionsum += ($d | (nzeros / length))
        | (.proportionsum / $i) as $propmean
	| if .first
	  then if $propmean > $goal then .first = null else . end
	  elif $propmean <= $goal then .first = $i
	  else .
	  end)
    | "Mean proportion of zero digits in factorials to \($N) is \(.proportionsum/$N);" +
       (if .first then " mean <= \($goal) from N=\(.first) on." else " goal (\($goal)) unmet." end);

# The task:
100, 1000, 10000 | meanfactorialdigits
