def anagrams:
  (reduce .[] as $word (
      {table: {}, max: 0};   # state
      ($word | explode | sort | implode) as $hash
      | .table = ( .table + { ($hash): ( .table[$hash] + [ $word ]) })
      | .max   = ([ .max, ( .table[$hash] | length) ] | max ) ))
  | .max as $max
  | .table | .[] | select(length == $max) ;

# The task:
split("\n") | anagrams
