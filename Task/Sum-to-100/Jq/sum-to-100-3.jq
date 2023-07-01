def histogram(s): reduce s as $x ({}; ($x|tostring) as $k | .[$k] += 1);

# Emit an array of [ value, frequency ] pairs
def greatest(n):
  to_entries
  | map( [.key, .value] )
  | sort_by(.[1])
  | .[(length-n):]
  | reverse ;
