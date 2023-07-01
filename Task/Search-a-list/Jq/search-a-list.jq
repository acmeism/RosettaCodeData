["a","b","c"] | index("b")
# => 1

["a","b","c","b"] | index("b")
# => 1

["a","b","c","b"]
  | index("x") // error("element not found")
# => jq: error: element not found

# Extra task - the last element of an array can be retrieved
# using `rindex/` or by using -1 as an index into the array produced by `indices/1`:
["a","b","c","b","d"] | rindex("b")
# => 3

["a","b","c","b","d"] | indices("b")[-1]
# => 3
