# modes/0 produces an array of [value, count]
# in increasing order of count:
def modes:
  sort | reduce .[] as $i ([];
    # state variable is an array of [value, count]
    if length == 0 then [ [$i, 1] ]
    elif .[-1][0] == $i then setpath([-1,1]; .[-1][1] + 1)
    else . + [[$i,1]]
    end )
    | sort_by( .[1] );

# mode/0 outputs a stream of the modal values;
# if the input array is empty, the output stream is also empty.
def mode:
  if length == 0 then empty
  else modes as $modes
       | $modes[-1][1] as $count
       | $modes[] | select( .[1] == $count) | .[0]
   end;
