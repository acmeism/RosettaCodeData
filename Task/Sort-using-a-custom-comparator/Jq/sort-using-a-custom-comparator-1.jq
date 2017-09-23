def quicksort(cmp):
  if length < 2 then .                                     # it is already sorted
  else .[0] as $pivot
    | reduce .[] as $x
      # state: [less, equal, greater]
      ( [ [], [], [] ];                                    # three empty arrays:
        if   $x == $pivot then    .[1] += [$x]             # add x to equal
        else ([$x,$pivot]|cmp) as $order
          | if   $order == 0 then .[1] += [$x]             # ditto
            elif ($order|type) == "number" then
              if $order < 0 then  .[0] += [$x]             # add x to less
              else .[2] += [$x]                            # add x to greater
              end
            else ([$pivot,$x]|cmp) as $order2
              | if $order and $order2 then   .[1] += [$x]  # add x to equal
                elif $order then   .[0] += [$x]            # add x to less
                else .[2] += [$x]                          # add x to greater
                end
            end
        end )
    | (.[0] | quicksort(cmp) ) + .[1] + (.[2] | quicksort(cmp) )
  end ;
