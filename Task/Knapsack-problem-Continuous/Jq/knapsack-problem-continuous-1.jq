# continuous_knapsack(W) expects the input to be
# an array of objects {"name": _, "weight": _, "value": _}
# where "value" is the value of the given weight of the object.

def continuous_knapsack(W):
  map( .price = (if .weight > 0 then (.value/.weight) else 0 end) )
  | sort_by( .price )
  | reverse
  | reduce .[] as $item
      # state: [array, capacity]
      ([[], W];
       .[1] as $c
       | if $c <= 0 then .
         else ( [$item.weight, $c] | min) as $min
              | [.[0] + [ $item | (.weight = $min) | .value = (.price * $min)],
                ($c - $min) ]
         end)
  | .[1] as $remainder
  | .[0]
  | (.[] | {name, weight}),
    "Total value: \( map(.value) | add)",
    "Total weight: \(W - $remainder)" ;
