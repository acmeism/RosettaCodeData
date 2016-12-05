def setpaths(indices; values):
  reduce range(0; indices|length) as $i
    (.; .[indices[$i]] = values[$i]);

def disjointSort(indices):
  (indices|unique) as $ix   # "unique" sorts
  # Set $sorted to the sorted array of values at $ix:
  | ([ .[ $ix[] ] ] | sort) as $sorted
  | setpaths( $ix; $sorted) ;
