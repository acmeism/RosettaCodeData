import "./big" for BigInt
import "./hash" for HashSet
import "./sort" for Sort
import "./fmt" for Fmt

var potentialPowerful = Fn.new { |max, k|
    var indexes = List.filled(k, 1)
    var powerful = HashSet.new()
    var foundPower = true
    while (foundPower) {
        var genPowerful = false
        for (index in 0...k) {
            var power = BigInt.one
            for (i in 0...k) power = power * BigInt.new(indexes[i]).pow(k+i)
            if (power <= max) {
                powerful.add(power)
                indexes[0] = indexes[0] + 1
                genPowerful = true
                break
            }
            indexes[index] = 1
            if (index < k - 1) indexes[index+1] = indexes[index+1] + 1
        }
        if (!genPowerful) foundPower = false
    }
    return powerful.toList
}

var countPowerfulNumbers = Fn.new{ |max, k| potentialPowerful.call(max, k).count }

var getPowerfulNumbers = Fn.new { |max, k|
    var powerfulNumbers = potentialPowerful.call(max, k)
    Sort.quick(powerfulNumbers)
    return powerfulNumbers
}

for (k in 2..10) {
    var max = BigInt.ten.pow(k)
    var powerfulNumbers = getPowerfulNumbers.call(max, k)
    var count = powerfulNumbers.count
    Fmt.print("There are $d $d-powerful numbers between 1 and $i", count, k, max)
    Fmt.print("List: [$i ... $i]", powerfulNumbers[0..4], powerfulNumbers[-5..-1])
}
System.print()
for (k in 2..10) {
    var powCount = []
    for (j in 0...k+10) {
        var max = BigInt.ten.pow(j)
        powCount.add(countPowerfulNumbers.call(max, k))
    }
    Fmt.print("Count of $2d-powerful numbers <= 10^j, j in [0, $d]: $n", k, k + 9, powCount)
}
