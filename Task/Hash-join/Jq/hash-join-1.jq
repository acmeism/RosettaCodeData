# hashJoin(table1; key1; table2; key2) expects the two tables to be
# arrays, either of JSON objects, or of arrays.

# In the first case, that is, if the table's rows are represented as
# objects, then key1 should be the key of the join column of table1,
# and similarly for key2; if the join columns have different names,
# then they will both be included in the resultant objects.

# In the second case, that is, if the rows are arrays, then the
# 0-based indices of the join columns should be specified, and the
# rows are simply pasted together, resulting in duplication of the
# join columns.
#
def hashJoin(table1; key1; table2; key2):
  # collision-free hash function:
  def h:
    if type == "object" then with_entries(.value = (.value|h)) | tostring
    elif type == "array" then map(h)|tostring
    else (type[0:1]+tostring)
    end;

  # hash phase:
  reduce table1[] as $row
    ({};
     ($row[key1]|h) as $key
     | . + { ($key): (.[$key] + [$row]) } )
  | . as $hash
  # join phase
  | reduce table2[] as $row
      ([];
       ($row[key2]|h) as $key
       | if $hash|has($key) then
           reduce $hash[$key][] as $r (.; . +  [ $row + $r ] )
  	 else . end)
;
