# Input: an array of strings.
# Output: an object with the strings as keys,
# the values of which are the corresponding frequencies.
def counter:
  reduce .[] as $item ( {}; .[$item] += 1 ) ;

# entropy in bits of the input string
def entropy:
  (explode | map( [.] | implode ) | counter | [ .[] | . * log ] | add) as $sum
  | ((length|log) - ($sum / length)) / (2|log) ;
