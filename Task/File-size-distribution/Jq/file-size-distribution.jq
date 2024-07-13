# bag of words
def bow(stream):
  reduce stream as $word ({}; .[($word|tostring)] += 1);

# `stream` is expected to be a stream of non-negative numbers or numeric strings.
# The output is a stream of [bucket, count] pairs, sorted by the value of `bucket`.
# No sorting except for the sorting of these bucket boundaries takes place.
def histogram(stream):
  bow(stream)
  | to_entries
  | map( [(.key | tonumber), .value] )
  | sort_by(.[0])
  | .[];

histogram(.[] | .size | if . == 0 then 0 else 1 + (log10 | trunc) end)
