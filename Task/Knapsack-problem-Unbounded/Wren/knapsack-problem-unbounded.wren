import "./fmt" for Fmt

class Item {
    construct new(name, value, weight, volume) {
        _name   = name
        _value  = value
        _weight = weight
        _volume = volume
    }

    name   { _name   }
    value  { _value  }
    weight { _weight }
    volume { _volume }
}

var items = [
    Item.new("panacea", 3000, 0.3, 0.025),
    Item.new("ichor", 1800, 0.2, 0.015),
    Item.new("gold", 2500, 2, 0.002)
]

var n = items.count
var count = List.filled(n, 0)
var best = List.filled(n, 0)
var bestValue = 0
var maxWeight = 25
var maxVolume = 0.25

var knapsack // recursive
knapsack = Fn.new { |i, value, weight, volume|
    if (i == n) {
        if (value > bestValue) {
            bestValue = value
            for (j in 0...n) best[j] = count[j]
        }
        return
    }
    var m1 = (weight / items[i].weight).floor
    var m2 = (volume / items[i].volume).floor
    count[i] = m1.min(m2)
    while (count[i] >= 0) {
        knapsack.call(
            i + 1,
            value  + count[i] * items[i].value,
            weight - count[i] * items[i].weight,
            volume - count[i] * items[i].volume
        )
        count[i] = count[i] - 1
    }
}

knapsack.call(0, 0, maxWeight, maxVolume)
System.print("Item Chosen  Number Value  Weight  Volume")
System.print("-----------  ------ -----  ------  ------")
var itemCount = 0
var sumNumber = 0
var sumWeight = 0
var sumVolume = 0
for (i in 0... n) {
    if (best[i] != 0) {
        itemCount  = itemCount + 1
        var name   = items[i].name
        var number = best[i]
        var value  = items[i].value  * number
        var weight = items[i].weight * number
        var volume = items[i].volume * number
        sumNumber  = sumNumber + number
        sumWeight  = sumWeight + weight
        sumVolume  = sumVolume + volume
        Fmt.write("$-11s   $2d    $5.0f   $4.1f", name, number, value, weight)
        Fmt.print("    $4.2f", volume)
    }
}
System.print("-----------  ------ -----  ------  ------")
Fmt.write("$d items       $2d    $5.0f   $4.1f", itemCount, sumNumber, bestValue, sumWeight)
Fmt.print("    $4.2f", sumVolume)
