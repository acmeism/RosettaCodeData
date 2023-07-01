# hash(keys) creates a JSON object with the given keys as keys
# and values taken from the input array in turn.
# "keys" must be an array of strings.
# The input array may be of any length and have values of any type,
# but only the first (keys|length) values will be used;
# the input will in effect be padded with nulls if required.
def hash(keys):
  . as $values
  | reduce range(0; keys|length) as $i
      ( {}; . + { (keys[$i]) : $values[$i] });

[1,2,3] | hash( ["a","b","c"] )
