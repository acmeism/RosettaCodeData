import algorithm
import strformat

type Item = object
  name: string
  weight: float
  price: float
  unitPrice: float

var items = @[Item(name: "beef", weight: 3.8, price: 36.0),
              Item(name: "pork", weight: 5.4, price: 43.0),
              Item(name: "ham", weight: 3.6, price: 90.0),
              Item(name: "greaves", weight: 2.4, price: 45.0),
              Item(name: "flitch", weight: 4.0, price: 30.0),
              Item(name: "brawn", weight: 2.5, price: 56.0),
              Item(name: "welt", weight: 3.7, price: 67.0),
              Item(name: "salami", weight: 3.0, price: 95.0),
              Item(name: "sausage", weight: 5.9, price: 98.0)
             ]
                        ]
# Compute unit prices and sort items by decreasing unit price.
for item in items.mitems:
  item.unitPrice = item.price / item.weight
items.sort(proc (x, y: Item): int = cmp(x.unitPrice, y.unitPrice), Descending)

var remaining = 15.0
var value = 0.0
for item in items:
  if item.weight <= remaining:
    echo fmt"Take all {item.name}"
    value += item.price
    remaining -= item.weight
  else:
    echo fmt"Take {remaining} kg of {item.name}"
    value += remaining * item.unitPrice
    break

echo fmt"Total value: {value:.2f}"
