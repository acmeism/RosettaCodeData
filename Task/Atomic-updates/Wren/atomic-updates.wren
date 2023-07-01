import "random" for Random
import "scheduler" for Scheduler
import "timer" for Timer
import "/math" for Nums

var Rnd = Random.new()

var NUM_BUCKETS = 10
var MAX_VALUE   = 9999

class Buckets {
    construct new(data) {
        _data = data.toList
        _running = true
    }

    [index] { _data[index] }

    transfer(srcIndex, dstIndex, amount) {
        if (amount < 0) Fiber.abort("Negative amount: %(amount)")
        if (amount == 0) return 0
        var a = amount
        if (_data[srcIndex] - a < 0) a = _data[srcIndex]
        if (_data[dstIndex] + a < 0) a = MAX_VALUE - _data[dstIndex]
        if (a < 0) Fiber.abort("Negative amount: %(a)")
        _data[srcIndex] = _data[srcIndex] - a
        _data[dstIndex] = _data[dstIndex] + a
        return a
    }

    buckets { _data.toList }

    transferRandomAmount() {
        while (_running) {
            var srcIndex = Rnd.int(NUM_BUCKETS)
            var dstIndex = Rnd.int(NUM_BUCKETS)
            var amount   = Rnd.int(MAX_VALUE + 1)
            transfer(srcIndex, dstIndex, amount)
            Timer.sleep(1)
        }
    }

    equalize() {
        while (_running) {
            var srcIndex = Rnd.int(NUM_BUCKETS)
            var dstIndex = Rnd.int(NUM_BUCKETS)
            var amount = ((this[srcIndex] - this[dstIndex])/2).truncate
            if (amount >= 0) transfer(srcIndex, dstIndex, amount)
            Timer.sleep(1)
        }
    }

    stop() { _running = false }

    print() {
        Timer.sleep(1000) // one second delay between prints
        var bucketValues = buckets
        System.print("Current values: %(Nums.sum(bucketValues)) %(bucketValues)")
    }
}

var values = List.filled(NUM_BUCKETS, 0)
for (i in 0...NUM_BUCKETS) values[i] = Rnd.int(MAX_VALUE + 1)
System.print("Initial array : %(Nums.sum(values)) %(values)")
var buckets = Buckets.new(values)
var count = 0
while (true) {
    Scheduler.add {
        buckets.equalize()
    }
    buckets.print()
    Scheduler.add {
        buckets.transferRandomAmount()
    }
    buckets.print()
    count = count + 2
    if (count == 10) {  // stop after 10 prints, say
        buckets.stop()
        break
    }
}
