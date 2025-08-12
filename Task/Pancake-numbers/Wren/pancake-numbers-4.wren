import "./fmt" for Fmt

class Queue {
    construct new(limit) {
        _limit = limit
        _first = 0
        _last  = -1
        _list = []
    }

    isEmpty { _first > _last }

    push(v) {
        _last = _last + 1
        _list.add(v)
    }

    // Doesn't actually remove the first element from the internal list.
    // Just changes a pointer so that the next element (if any) becomes the first.
    // However, when the number of popped elements reaches _limit, they are
    // cleared out and the pointers reset.
    pop() {
        if (isEmpty) Fiber.abort("Queue is empty.")
        var value = _list[_first]
        _first = _first + 1
        if (_first == _limit) {
            _list = _list[_first..-1]
            _first = 0
            _last = _last - _limit
        }
        return value
    }
}

// Flip the stack of pancakes at the given position.
var flip = Fn.new { |pancakes, pos, n|
    pancakes = pancakes.toString
    if (n == 10 && pancakes.count == 9) pancakes = "0" + pancakes
    return Num.fromString(pancakes[0...pos][-1..0] + pancakes[pos..-1])
}

// Finds the maximum value in 'map' and returns the first key
// it finds (iteration order is undefined) with that value
// and the value itself.
var findMax = Fn.new { |map|
    var max = -1
    var maxKey = null
    for (me in map) {
        if (me.value > max) {
            max = me.value
            maxKey = me.key
        }
    }
    return [maxKey, max]
}

// Return the nth pancake number.
var pancake = Fn.new { |n|
    var initStack = n < 10 ? (1..n).join("") : (1..9).join("") + "0"
    initStack = Num.fromString(initStack)
    var stackFlips = { initStack: 0 }
    var queue = Queue.new(100000) // say
    queue.push(initStack)
    while (!queue.isEmpty) {
        var stack = queue.pop()
        var flips = stackFlips[stack] + 1
        var i = 2
        while (i <= n) {
            var flipped = flip.call(stack, i, n)
            if (!stackFlips.containsKey(flipped)) {
                stackFlips[flipped] = flips
                queue.push(flipped)
            }
            i = i + 1
        }
    }
    return findMax.call(stackFlips)
}

var start = System.clock
System.print("The maximum number of flips to sort a given number of elements is:")
for (n in 1..10) {
    var res = pancake.call(n)
    res[0] = res[0].toString.map{ |c| c }.toList
    if (n == 10 && res[0].count == 9) res[0].insert(0, "0")
    var pancakes = "[" + res[0].join(", ") + "]"
    if (n == 10) pancakes = pancakes.replace("0", "10")
    var p = res[1]
    Fmt.print("pancake($2d) = $-2d  example: $n", n, p, pancakes)
}
System.print("\nTook %(System.clock - start) seconds.")
