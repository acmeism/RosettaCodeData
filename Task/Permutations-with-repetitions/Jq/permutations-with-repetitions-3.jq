# Input: the item to be matched
# Output: the index of the item in the stream (counting from 1);
# emit null if the item is not found
def sequence_number(stream):
  . as $in
  | (label $top
     | foreach stream as $i (0; .+1; if $in == $i then ., break $top else empty end))
    // null;  # NOTE: "//" here is an operator

["c", "a", "b"] | sequence_number( ["a","b","c"] | permutations_with_replacements(3))

# output: 20
