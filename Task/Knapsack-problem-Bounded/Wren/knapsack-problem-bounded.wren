import "./fmt" for Fmt

class Item {
    construct new(name, weight, value, count) {
        _name   = name
        _weight = weight
        _value  = value
        _count  = count
    }

    name   { _name   }
    weight { _weight }
    value  { _value  }
    count  { _count  }
}

var items = [
    Item.new("map", 9, 150, 1),
    Item.new("compass", 13, 35, 1),
    Item.new("water", 153, 200, 2),
    Item.new("sandwich", 50, 60, 2),
    Item.new("glucose", 15, 60, 2),
    Item.new("tin", 68, 45, 3),
    Item.new("banana", 27, 60, 3),
    Item.new("apple", 39, 40, 3),
    Item.new("cheese", 23, 30, 1),
    Item.new("beer", 52, 10, 3),
    Item.new("suntan cream", 11, 70, 1),
    Item.new("camera", 32, 30, 1),
    Item.new("T-shirt", 24, 15, 2),
    Item.new("trousers", 48, 10, 2),
    Item.new("umbrella", 73, 40, 1),
    Item.new("waterproof trousers", 42, 70, 1),
    Item.new("waterproof overclothes", 43, 75, 1),
    Item.new("note-case", 22, 80, 1),
    Item.new("sunglasses", 7, 20, 1),
    Item.new("towel", 18, 12, 2),
    Item.new("socks", 4, 50, 1),
    Item.new("book", 30, 10, 2)
]

var n = items.count
var maxWeight = 400

var knapsack = Fn.new { |w|
    var m = List.filled(n + 1, null)
    for (i in 0..n) m[i] = List.filled(w + 1, 0)
    for (i in 1..n) {
        for (j in 0..w) {
            m[i][j] = m[i-1][j]
            for (k in 1..items[i - 1].count) {
                if (k * items[i - 1].weight > j) break
                var v = m[i - 1][j - k * items[i - 1].weight] + k * items[i - 1].value
                if (v > m[i][j]) m[i][j] = v
            }
        }
    }
    var s = List.filled(n, 0)
    var j = w
    for (i in n..1) {
        var v = m[i][j]
        var k = 0
        while (v != m[i - 1][j] + k * items[i - 1].value) {
            s[i - 1] = s[i - 1] + 1
            j = j - items[i - 1].weight
            k = k + 1
        }
    }
    return s
}

var s = knapsack.call(maxWeight)
System.print("Item Chosen             Weight Value  Number")
System.print("---------------------   ------ -----  ------")
var itemCount = 0
var sumWeight = 0
var sumValue  = 0
var sumNumber = 0
for (i in 0... n) {
       if (s[i] != 0) {
           itemCount  = itemCount + 1
           var name   = items[i].name
           var number = s[i]
           var weight = items[i].weight * number
           var value  = items[i].value  * number
           sumNumber  = sumNumber + number
           sumWeight  = sumWeight + weight
           sumValue   = sumValue + value
           Fmt.print("$-22s    $3d   $4d    $2d", name, weight, value, number)
       }
}
System.print("---------------------   ------ -----  ------")
Fmt.print("Items chosen $d           $3d   $4d    $2d", itemCount, sumWeight, sumValue, sumNumber)
