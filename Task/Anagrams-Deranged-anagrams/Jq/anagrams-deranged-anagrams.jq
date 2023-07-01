# Input: an array of strings
# Output: a stream of arrays
def anagrams:
  reduce .[] as $word (
    {table: {}, max: 0};   # state
    ($word | explode | sort | implode) as $hash
    | .table[$hash] += [ $word ]
    | .max   = ([ .max, ( .table[$hash] | length) ] | max ) )
  | .table | .[]  | select(length>1);

# Check whether the input and y are deranged,
# on the assumption that they are anagrams:
def deranged(y):
  explode as $x                             # explode is fast
  | (y | explode) as $y
  | all( range(0;length); $x[.] != $y[.] );

# The task: loop through the anagrams,
# retaining only the best set of deranged anagrams so far.
split("\n") | select(length>0)              # read all the words as an array
| reduce anagrams as $words ([];            # loop through all the anagrams
    reduce $words[] as $v (.;
      reduce ($words - [$v])[] as $w (.;    # $v and $w are distinct members of $words
        if $v|deranged($w)
        then if length == 0 then [$v,$w]
             elif ($v|length) == (.[0]|length) then . + [$v,$w]
             elif ($v|length) >  (.[0]|length) then [$v,$w]
	     else .
	     end
        else .
        end) ) )
| unique
