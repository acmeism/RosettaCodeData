import "random" for Random

var rand = Random.new()

var randNormal = Fn.new { (-2 * rand.float().log).sqrt * (2 * Num.pi * rand.float()).cos }

var stdDev = Fn.new { |a, m|
    var c = a.count
    return ((a.reduce(0) { |acc, x| acc + x*x } - m*m*c) / c).sqrt
}

var n = 1000
var numbers = List.filled(n, 0)
var mu = 1
var sigma = 0.5
var sum = 0
for (i in 0...n) {
    numbers[i] = mu + sigma*randNormal.call()
    sum = sum + numbers[i]
}
var mean = sum / n
System.print("Actual mean   : %(mean)")
System.print("Actual std dev: %(stdDev.call(numbers, mean))")
