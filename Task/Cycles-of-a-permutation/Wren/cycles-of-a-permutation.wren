import "./math" for Int
import "./fmt" for Fmt

/*
    It's assumed throughout that string arguments are always 15 characters long
    and consist of unique upper case letters.
*/
class PC {

    // Private method to shift a cycle one place to the left.
    static shiftLeft_(cycle) {
        var c = cycle.count
        var first = cycle[0]
        for (i in 1...c) cycle[i-1] = cycle[i]
        cycle[-1] = first
    }

    // Private method to arrange a cycle so the lowest element is first.
    static smallestFirst_(cycle) {
        var c = cycle.count
        var min = cycle[0]
        var minIx = 0
        for (i in 1...c) {
            if (cycle[i] < min) {
                min = cycle[i]
                minIx = i
            }
        }
        if (minIx == 0) return
        for (i in 1..minIx) shiftLeft_(cycle)
    }

    // Converts a list in one line notation to a space separated string.
    static oneLineToString(ol) { ol.join(" ") }

    // Converts a list in cycle notation to a string where each cycle is space separated
    // and enclosed in parentheses.
    static cyclesToString(cycles) {
        var cycles2 = []
        for (cycle in cycles) cycles2.add("(" + cycle.join(" ") + ")")
        return cycles2.toString
    }

    // Returns a list in one line notation derived from two strings s and t.
    static oneLineNotation(s, t) {
        var res = List.filled(15, 0)
        for (i in 0..14) res[i] = s.indexOf(t[i]) + 1
        for (i in 14..0) {
            if (res[i] != i + 1) break
            res.removeAt(i)
        }
        return res
    }

    // Returns a list in cycle notation derived from two strings s and t.
    static cycleNotation(s, t) {
        var used = List.filled(15, false)
        var cycles = []
        for (i in 0..14) {
            if (used[i]) continue
            var cycle = []
            used[i] = true
            var ix = t.indexOf(s[i])
            if (i == ix) continue
            cycle.add(i+1)
            while (true) {
               cycle.add(ix + 1)
               used[ix] = true
               ix = t.indexOf(s[ix])
               if (cycle[0] == ix + 1) {
                   smallestFirst_(cycle)
                   cycles.add(cycle)
                   break
               }
            }
        }
        return cycles
    }

    // Converts a list in one line notation to its inverse.
    static oneLineInverse(oneLine) {
        var c = oneLine.count
        var s = oneLine.map { |b| String.fromByte(b + 64) }.join()
        if (c < 15) {
            for (i in c..15) s = s + String.fromByte(c + 65)
        }
        var t = (0..14).map { |b| String.fromByte(b + 65) }.join()
        return oneLineNotation(s, t)
    }

    // Converts a list of cycles to its inverse.
    static cycleInverse(cycles) {
        var cycles2 = []
        for (i in 0...cycles.count) {
            var cycle = cycles[i][-1..0]
            smallestFirst_(cycle)
            cycles2.add(cycle)
        }
        return cycles2
    }

    // Permutes a string using perm in one line notation.
    static oneLinePermute(s, perm) {
        var c = perm.count
        var t = List.filled(15, "")
        for (i in 0...c) t[i] = s[perm[i]-1]
        if (c < 15) {
            for (i in c..14) t[i] = s[i]
        }
        return t.join()
    }

    // Permutes a string using perm in cycle notation.
    static cyclePermute(s, cycles) {
        var t = List.filled(15, "")
        for (cycle in cycles) {
            for (i in 0...cycle.count-1) {
                t[cycle[i+1]-1] = s[cycle[i]-1]
            }
            t[cycle[0]-1] = s[cycle[-1]-1]
        }
        for (i in 0..14) if (t[i] == "") t[i] = s[i]
        return t.join()
    }

    // Returns a single perm in cycle notation resulting from applying
    // cycles1 first and then cycles2.
    static cycleCombine(cycles1, cycles2) {
        var s = (0..14).map { |b| String.fromByte(b + 65) }.join()
        var t = cyclePermute(s, cycles1)
        t = cyclePermute(t, cycles2)
        return cycleNotation(s, t)
    }

    // Converts a list in one line notation to cycle notation.
    static oneLineToCycle(oneLine) {
        var c = oneLine.count
        var t = oneLine.map { |b| String.fromByte(b + 64) }.join()
        if (c < 15) {
            for (i in c..15) t = t + String.fromByte(c + 65)
        }
        var s = (0..14).map { |b| String.fromByte(b + 65) }.join()
        return cycleNotation(s, t)
    }

    // Converts a list in cycle notation to one line notation.
    static cycleToOneLine(cycles) {
        var s = (0..14).map { |b| String.fromByte(b + 65) }.join()
        var t = cyclePermute(s, cycles)
        return oneLineNotation(s, t)
    }

    // Returns the order of a permutation.
    static order(cycles) {
       var lens = []
       for (cycle in cycles) lens.add(cycle.count)
       return Int.lcm(lens)
    }

    // Returns the signature of a permutation.
    static signature(cycles) {
       var count = 0
       for (cycle in cycles) if (cycle.count % 2 == 0) count = count + 1
       return (count % 2 == 0) ? 1 : -1
    }
}

var letters = [
    "HANDYCOILSERUPT",  // Monday
    "SPOILUNDERYACHT",  // Tuesday
    "DRAINSTYLEPOUCH",  // Wednesday
    "DITCHSYRUPALONE",  // Thursday
    "SOAPYTHIRDUNCLE",  // Friday
    "SHINEPARTYCLOUD",  // Saturday
    "RADIOLUNCHTYPES"   // Sunday
]

System.print("On Thursdays Alf and Betty should rearrange their letters using these cycles:")
var cycles = PC.cycleNotation(letters[2], letters[3])
System.print(PC.cyclesToString(cycles))
System.print("So that %(letters[2]) becomes %(PC.cyclePermute(letters[2], cycles))")

System.print("\nOr they could use the one line notation:")
var oneLine = PC.cycleToOneLine(cycles)
System.print(PC.oneLineToString(oneLine))

System.print("\nTo revert to the Wednesday arrangement they should use these cycles:")
var cycles2 = PC.cycleInverse(cycles)
System.print(PC.cyclesToString(cycles2))

System.print("\nOr with the one line notation:")
var oneLine2 = PC.oneLineInverse(oneLine)
System.print(PC.oneLineToString(oneLine2))
System.print("So that %(letters[3]) becomes %(PC.oneLinePermute(letters[3], oneLine2))")

System.print("\nStarting with the Sunday arrangement and applying each of the daily arrangements")
System.print("consecutively, the arrangements will be:")

var days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
System.print("\n     %(letters[6])\n")
for (j in 0..6) {
    if (j == 6) System.print()
    System.write(days[j] + ": ")
    var i = (j == 0) ? 6 : j - 1
    var ol = PC.oneLineNotation(letters[i], letters[j])
    System.print(PC.oneLinePermute(letters[i], ol))
}

System.print("\nTo go from Wednesday to Friday in a single step they should use these cycles:")
var cycles3 = PC.cycleNotation(letters[3], letters[4])
var cycles4 = PC.cycleCombine(cycles, cycles3)
System.print(PC.cyclesToString(cycles4))
System.print("So that %(letters[2]) becomes %(PC.cyclePermute(letters[2], cycles4))")

System.print("\nThese are the signatures of the permutations:")
System.print(days.join(" "))
for (j in 0..6) {
    var i = (j == 0) ? 6 : j - 1
    var cy = PC.cycleNotation(letters[i], letters[j])
    Fmt.write("$2d  ", PC.signature(cy))
}
System.print()

System.print("\nThese are the orders of the permutations:")
System.print(days.join(" "))
for (j in 0..6) {
    var i = (j == 0) ? 6 : j - 1
    var cy = PC.cycleNotation(letters[i], letters[j])
    Fmt.write("$3d ", PC.order(cy))
}
System.print()

System.print("\nApplying the Friday cycle to a string 10 times:")
var prev = "STOREDAILYPUNCH"
System.print("\n   %(prev)\n")
for (i in 1..10) {
    if (i == 10) System.print()
    Fmt.write("$2d ", i)
    prev = PC.cyclePermute(prev, cycles3)
    System.print(prev)
}
