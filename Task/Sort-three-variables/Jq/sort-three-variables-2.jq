def sortVariables:
  keys_unsorted as $keys
  | ([.[]] | sort) as $values
  | reduce range(0; $keys|length) as $i ({}; .[$keys[$i]] = ($values[$i]) ) ;
