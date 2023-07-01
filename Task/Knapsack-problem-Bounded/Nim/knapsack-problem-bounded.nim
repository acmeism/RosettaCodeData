# Knapsack. Recursive solution.

import strformat
import tables

# Description of an item.
type Item = tuple[name: string; weight, value, pieces: int]

# List of available items.
const Items: seq[Item] = @[("map", 9, 150, 1),
                           ("compass", 13, 35, 1),
                           ("water", 153, 200, 2),
                           ("sandwich", 50, 60, 2),
                           ("glucose", 15, 60, 2),
                           ("tin", 68, 45, 3),
                           ("banana", 27, 60, 3),
                           ("apple", 39, 40, 3),
                           ("cheese", 23, 30, 1),
                           ("beer", 52, 10, 3),
                           ("suntan cream", 11, 70, 1),
                           ("camera", 32, 30, 1),
                           ("T-shirt", 24, 15, 2),
                           ("trousers", 48, 10, 2),
                           ("umbrella", 73, 40, 1),
                           ("waterproof trousers", 42, 70, 1),
                           ("waterproof overclothes", 43, 75, 1),
                           ("note-case", 22, 80, 1),
                           ("sunglasses", 7, 20, 1),
                           ("towel", 18, 12, 2),
                           ("socks", 4, 50, 1),
                           ("book", 30, 10, 2)
                          ]

type

  # Item numbers (used rather than items themselves).
  Number = range[0..Items.high]

  # Description of an expanded item.
  ExpandedItem = tuple[num: Number; weight, value: int]


# Expanded items management.

proc expandedItems(items: seq[Item]): seq[ExpandedItem] =
  ## Expand the list of items.
  for idx, item in Items:
    for _ in 1..item.pieces:
      result.add((idx.Number, item.weight, item.value))

const ItemList = expandedItems(Items)

type

  # Index in the expanded list.
  ExpandedIndex = 0..ItemList.high

  # Chosen items and their total value.
  Choice = tuple[indexes: set[ExpandedIndex]; weight, value: int]

# Cache used to speed up the search.
var cache: Table[tuple[index, weight: int], Choice]


#---------------------------------------------------------------------------------------------------

proc select(idx, weightLimit: int): Choice =
  ## Find the best choice starting from item at index "idx".

  if idx < 0 or weightLimit == 0:
    return

  if (idx, weightLimit) in cache:
    return cache[(idx, weightLimit)]

  let weight = ItemList[idx].weight
  if weight > weightLimit:
    return select(idx - 1, weightLimit)

  # Try by leaving this item and selecting among remaining items.
  result = select(idx - 1, weightLimit)

  # Try by taking this item and completing with some remaining items.
  var result1 = select(idx - 1, weightLimit - weight)
  inc result1.value, ItemList[idx].value

  # Select the best choice (giving the greater value).
  if result1.value > result.value:
    result = (result1.indexes + {idx.ExpandedIndex}, result1.weight + weight, result1.value)

  cache[(idx, weightLimit)] = result

#---------------------------------------------------------------------------------------------------

let (indexes, weight, value) = select(ItemList.high, 400)

# Count the number of pieces for each item.
var pieces = newSeq[int](Items.len)
for idx in indexes:
  inc pieces[ItemList[idx].num]

echo "List of items:"
for num in 0..Items.high:
  if pieces[num] > 0:
    echo fmt"– {pieces[num]} of {Items[num].pieces} {Items[num].name}"
echo ""
echo "Total weight: ", weight
echo "Total value: ", value
