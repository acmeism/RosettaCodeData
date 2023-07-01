import "/fmt" for Fmt
import "/math" for Math
import "/sort" for Sort

class Item {
    construct new(name, weight, value) {
        _name   = name
        _weight = weight
        _value  = value
    }

    name   { _name   }
    weight { _weight }
    value  { _value  }
}

var items = [
    Item.new("beef", 3.8, 36),
    Item.new("pork", 5.4, 43),
    Item.new("ham", 3.6, 90),
    Item.new("greaves", 2.4, 45),
    Item.new("flitch", 4, 30),
    Item.new("brawn", 2.5, 56),
    Item.new("welt", 3.7, 67),
    Item.new("salami", 3.0, 95),
    Item.new("sausage", 5.9, 98)
]

var maxWeight = 15
// sort items by value per unit weight in descending order
var cmp = Fn.new { |i, j| (j.value/j.weight - i.value/i.weight).sign }
Sort.insertion(items, cmp)
System.print("Item Chosen   Weight  Value  Percentage")
System.print("-----------   ------ ------  ----------")
var w = maxWeight
var itemCount = 0
var sumValue = 0
for (item in items) {
    itemCount = itemCount + 1
    if (item.weight <= w) {
       sumValue = sumValue + item.value
       Fmt.print("$-11s     $3.1f   $5.2f    100.00", item.name, item.weight, item.value)
    } else {
       var value  = Math.toPlaces(w / item.weight * item.value, 2)
       var percentage = Math.toPlaces(w / item.weight * 100, 2)
       sumValue = sumValue + value
       Fmt.print("$-11s     $3.1f   $5.2f    $6.2f", item.name, w, value, percentage)
       break
    }
    w = w - item.weight
    if (w == 0) break
}
System.print("-----------   ------ ------")
Fmt.print("$d items        15.0  $6.2f", itemCount, sumValue)
