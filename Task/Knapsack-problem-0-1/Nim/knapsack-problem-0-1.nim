# Knapsack. Recursive algorithm.

import algorithm
import sequtils
import tables

# Description of an item.
type Item = tuple[name: string; weight, value: int]

# List of available items.
const Items: seq[Item] = @[("map", 9, 150),
                           ("compass", 13, 35),
                           ("water", 153, 200),
                           ("sandwich", 50, 160),
                           ("glucose", 15, 60),
                           ("tin", 68, 45),
                           ("banana", 27, 60),
                           ("apple", 39, 40),
                           ("cheese", 23, 30),
                           ("beer", 52, 10),
                           ("suntan cream", 11, 70),
                           ("camera", 32, 30),
                           ("T-shirt", 24, 15),
                           ("trousers", 48, 10),
                           ("umbrella", 73, 40),
                           ("waterproof trousers", 42, 70),
                           ("waterproof overclothes", 43, 75),
                           ("note-case", 22, 80),
                           ("sunglasses", 7, 20),
                           ("towel", 18, 12),
                           ("socks", 4, 50),
                           ("book", 30, 10)
                          ]

type

  # Item numbers (used rather than items themselves).
  Number = range[0..Items.high]

  # Chosen items and their total value.
  Choice = tuple[nums: set[Number]; weight, value: int]

# Cache used to speed up the search.
var cache: Table[tuple[num, weight: int], Choice]

#---------------------------------------------------------------------------------------------------

proc select(num, weightLimit: int): Choice =
  ## Find the best choice starting from item at index "num".

  if num < 0 or weightLimit == 0:
    return

  if (num, weightLimit) in cache:
    return cache[(num, weightLimit)]

  let weight = Items[num].weight
  if weight > weightLimit:
    return select(num - 1, weightLimit)

  # Try by leaving this item and selecting among remaining items.
  result = select(num - 1, weightLimit)

  # Try by taking this item and completing with some remaining items.
  var result1 = select(num - 1, weightLimit - weight)
  inc result1.value, Items[num].value

  # Select the best choice (giving the greater value).
  if result1.value > result.value:
    result = (result1.nums + {num.Number}, result1.weight + weight, result1.value)

  cache[(num, weightLimit)] = result

#---------------------------------------------------------------------------------------------------

let (nums, weight, value) = select(Items.high, 400)
echo "List of items:"
for num in sorted(toSeq(nums)):
  echo "– ", Items[num].name
echo ""
echo "Total weight: ", weight
echo "Total value: ", value
