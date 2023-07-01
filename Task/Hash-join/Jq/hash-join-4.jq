# The tables should be arrays of arrays;
# index1 and index2 should be the 0-based indices of the join columns.
#
def hashJoinArrays(table1; index1; table2; index2):
  # collision-free hash function:
  def h:
    if type == "object" then with_entries(.value = (.value|h)) | tostring
    elif type == "array" then map(h)|tostring
    else (type[0:1]+tostring)
    end;

  # hash phase:
  reduce table1[] as $row
    ({};
     ($row[index1]|h) as $key
     | . + (.[$key] += [ $row ])  )
  | . as $hash
  # join phase
  | reduce table2[] as $row
      ([];
       ($row[index2]|h) as $key
       | if $hash|has($key) then
           reduce $hash[$key][] as $r
	     (.;
	      . + [ $r + $row[0:index2] + $row[index2+1:] ] )
  	 else . end)
;
