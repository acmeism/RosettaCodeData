def quicksort:
  if length < 2 then .                            # it is already sorted
  else .[0] as $pivot
       | reduce .[] as $x
         # state: [less, equal, greater]
           ( [ [], [], [] ];                      # three empty arrays:
             if   $x  < $pivot then .[0] += [$x]  # add x to less
             elif $x == $pivot then .[1] += [$x]  # add x to equal
             else                   .[2] += [$x]  # add x to greater
             end
         )
       | (.[0] | quicksort ) + .[1] + (.[2] | quicksort )
  end ;
