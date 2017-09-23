# Input: an array of strings.
# Output: an object with the strings as keys,
# the values of which are the corresponding frequencies.
def counter:
  reduce .[] as $item ( {}; .[$item] += 1 ) ;

# For neatness we sort the keys:
explode | map( [.] | implode ) | counter | . as $counter
 | keys | sort[] | [., $counter[.] ]
