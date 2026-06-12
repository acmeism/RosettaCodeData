import "random" for Random

var rand = Random.new()

// the function being learned is f(x) = 2x + 1
var targetOutput = Fn.new { |a, b| (a * 2 + 1 < b) ? 1 : -1 }

var showTargetOutput = Fn.new {
    for (y in 10..-9) {
        for (x in -9..10) {
            if (targetOutput.call(x, y) == 1) {
                System.write("#")
            } else {
                System.write("O")
            }
        }
        System.print()
    }
    System.print()
}

var randomWeights = Fn.new { |ws|
   for (i in 0..2) ws[i] = rand.float() * 2 - 1
}

var feedForward = Fn.new { |ins, ws|
   // the perceptron outputs 1 if the sum of its inputs multiplied by
   // its input weights is positive, otherwise -1
   var sum = 0
   for (i in 0..2) sum = sum + ins[i] * ws[i]
   return (sum > 0) ? 1 : -1
}

var showOutput = Fn.new { |ws|
    var inputs = List.filled(3, 0)
    inputs[2] = 1  // bias
    for (y in 10..-9) {
        for (x in -9..10) {
            inputs[0] = x
            inputs[1] = y
            if (feedForward.call(inputs, ws) == 1) {
                System.write("#")
            } else {
                System.write("O")
            }
        }
        System.print()
    }
    System.print()
}

var train = Fn.new { |ws, runs|
    var inputs = List.filled(3, 0)
    inputs[2] = 1  // bias
    for (i in 1..runs) {
        for (y in 10..-9) {
            for (x in -9..10) {
                inputs[0] = x
                inputs[1] = y
                var error = targetOutput.call(x, y) - feedForward.call(inputs, ws)
                for (j in 0..2) {
                    ws[j] = ws[j] + error * inputs[j] * 0.01 // 0.01 is the learning constant
                }
            }
        }
    }
}

var weights = List.filled(3, 0)
System.print("Target output for the function f(x) = 2x + 1:")
showTargetOutput.call()
randomWeights.call(weights)
System.print("Output from untrained perceptron:")
showOutput.call(weights)
train.call(weights, 1)
System.print("Output from perceptron after 1 training run:")
showOutput.call(weights)
train.call(weights, 4)
System.print("Output from perceptron after 5 training runs:")
showOutput.call(weights)
