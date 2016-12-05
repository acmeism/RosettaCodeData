# Sort by string length, breaking ties using ordinary string comparison.
["z", "yz", "ab", "c"]
  | quicksort( (.[0]|length) > (.[1]|length) or ( (.[0]|length) == (.[1]|length) and .[0] < .[1] ) )
