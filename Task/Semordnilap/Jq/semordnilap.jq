# Produce a stream
def report:
  split("\n") as $list
  # construct the dictionary:
  | (reduce $list[] as $entry ({}; . + {($entry): 1})) as $dict
  # construct the list of semordnilaps:
  | $list[]
  | select( (explode|reverse|implode) as $rev
            | (. < $rev and $dict[$rev]) );

[report] | (.[0:5][],  "length = \(length)")
