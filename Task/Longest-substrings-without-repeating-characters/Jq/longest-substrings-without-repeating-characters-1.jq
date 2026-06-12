# Use a dictionary for speed in case of very long strings
def alluniquehead:
  length as $n
  | if $n <= 1 then .
    else . as $in
    | {ix: -1}
    | until(.i or (.ix == $n);
         .ix += 1
         | $in[.ix:.ix+1] as $x
	 | if .dict[$x] then .i = .ix
	   else .dict[$x] = true
           end )
    | $in[: .ix]
    end ;

def maximal_substring_with_distinct_characters:
  . as $in
  | length as $n
  | {i: -1}
  | until( .i == $n or .stop;
      .i += 1
      | if .max and .max > $n - .i then .stop = true
        else ($in[.i:] | alluniquehead) as $head
	| if ($head|length) > .max
	  then .ans = $head
	  | .max = ($head|length)
	  else .
	  end
	end)
  | .ans;	
