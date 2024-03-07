import "./fmt" for Fmt

// Converts a string of the form "[1, 2]" into a list: [1, 2]
var asList = Fn.new { |s|
    var split = s[1..-2].split(", ")
    return split.map { |n| Num.fromString(n) }.toList
}

// Merges two maps into one. If the same key is present in both maps
// its value will be the one in the second map.
var mergeMaps = Fn.new { |m1, m2|
    var m3 = {}
    for (key in m1.keys) m3[key] = m1[key]
    for (key in m2.keys) m3[key] = m2[key]
    return m3
}

// Finds the maximum value in 'dict' and returns the first key
// it finds (iteration order is undefined) with that value.
var findMax = Fn.new { |dict|
    var max = -1
    var maxKey = null
    for (me in dict) {
        if (me.value > max) {
            max = me.value
            maxKey = me.key
        }
    }
    return maxKey
}

var pancake = Fn.new { |len|
    var numStacks = 1
    var goalStack = (1..len).toList.toString
    var stacks = {goalStack: 0}
    var newStacks = {goalStack: 0}
    for (i in 1..1000) {
        var nextStacks = {}
        for (key in newStacks.keys) {
            var arr = asList.call(key)
            var pos = 2
            while (pos <= len) {
                var newStack = (arr[pos-1..0] + arr[pos..-1]).toString
                if (!stacks.containsKey(newStack)) nextStacks[newStack] = i
                pos = pos + 1
            }
        }
        newStacks = nextStacks
        stacks = mergeMaps.call(stacks, newStacks)
        var perms = stacks.count
        if (perms == numStacks) return [findMax.call(stacks), i - 1]
        numStacks = perms
    }
}

var start = System.clock
System.print("The maximum number of flips to sort a given number of elements is:")
for (i in 1..9) {
    var res = pancake.call(i)
    var example = res[0]
    var steps = res[1]
    Fmt.print("pancake($d) = $-2d  example: $n", i, steps, example)
}
System.print("\nTook %(System.clock - start) seconds.")
