def lis:

  # Helper function:
  # given a stream, produce an array of the items in reverse order:
  def reverse(stream): reduce stream as $i ([]; [$i] + .);

  # put the items into increasing piles using the structure:
  # NODE = {"val": value, "back": NODE}
  reduce .[] as $x
    ( []; # array of NODE
      # binary search for the appropriate pile
      (map(.val) | bsearch($x)) as $i
      | setpath([$i];
                {"val": $x,
                 "back": (if $i > 0 then .[$i-1] else null end) })
    )
  | .[length - 1]
  | reverse( recurse(.back) | .val ) ;
