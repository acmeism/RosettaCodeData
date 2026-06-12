import "random" for Random
import "./math" for Nums
import "./fmt" for Fmt

var rand = Random.new()
var minDelta = 1

var getMaxPrice = Fn.new { |prices| Nums.max(prices) }

var getPrangeCount = Fn.new { |prices, min, max| prices.count { |p| p >= min && p <= max } }

var get5000 = Fn.new { |prices, min, max, n|
    var count = getPrangeCount.call(prices, min, max)
    var delta = (max - min) / 2
    while (count != n && delta >= minDelta/2) {
        max = ((count > n) ? max-delta : max+delta).floor
        count = getPrangeCount.call(prices, min, max)
        delta = delta / 2
    }
    return [max, count]
}

var getAll5000 = Fn.new { |prices, min, max, n|
    var mc = get5000.call(prices, min, max, n)
    var pmax = mc[0]
    var pcount = mc[1]
    var res = [[min, pmax, pcount]]
    while (pmax < max) {
        var pmin = pmax + 1
        mc = get5000.call(prices, pmin, max, n)
        pmax = mc[0]
        pcount = mc[1]
        if (pcount == 0) Fiber.abort("Price list from %(pmin) has too many with same price.")
        res.add([pmin, pmax, pcount])
    }
    return res
}
var numPrices = rand.int(99000, 101001)
var maxPrice = 1e5
var prices = List.filled(numPrices, 0) // list of prices
for (i in 1..numPrices) prices[i-1] = rand.int(maxPrice + 1)
var actualMax = getMaxPrice.call(prices)
System.print("Using %(numPrices) items with prices from 0 to %(actualMax):")
var res = getAll5000.call(prices, 0, actualMax, 5000)
System.print("Split into %(res.count) bins of approx 5000 elements:")
var total = 0
for (r in res) {
    var min = r[0]
    var max = r[1]
    if (max > actualMax) max = actualMax
    var cnt = r[2]
    total = total + cnt
    Fmt.print("   From $6d to $6d with $4d items", min, max, cnt)
}
if (total != numPrices) {
    System.print("Something went wrong - grand total of %(total) doesn't equal %(numPrices)!")
}
