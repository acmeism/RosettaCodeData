def disjoint_order(N):
  # The helper function, indices, ensures that successive occurrences
  # of a particular value in N are matched by successive occurrences
  # in the input on the assumption that null is not initially in the input.
  def indices:
    . as $in
    | reduce range(0; N|length) as $i
       # state: [ array, indices ]
      ( [$in, []];
        (.[0] | index(N[$i])) as $ix | .[0][$ix] = null | .[1] += [$ix])
    | .[1];

  . as $in
  | (indices | sort) as $sorted
  | reduce range(0; N|length) as $i ($in; .[$sorted[$i]] = N[$i] ) ;
