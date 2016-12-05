["a","b","c"] | index("b")
# => 1

["a","b","c","b"] | index("b")
# => 1

["a","b","c","b"]
  | index("x") as $ix
  | if $ix then $ix else error("element not found") end
# => jq: error: element not found

# Extra task - the last element of an array can be retrieved
# using -1 as an index:
["a","b","c","b","d"] | indices("b")[-1]
# => 3
