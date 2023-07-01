import "/dynamic" for Tuple

var Solution = Tuple.create("Solution", ["p", "tests", "swaps"])

// Holes A=0, B=1, …, H=7
// With connections:
var conn = "
       A   B
      /|\\ /|\\
     / | X | \\
    /  |/ \\|  \\
   C - D - E - F
    \\  |\\ /|  /
     \\ | X | /
      \\|/ \\|/
       G   H
"

var connections = [
	[0, 2], [0, 3], [0, 4], // A to C, D, E
	[1, 3], [1, 4], [1, 5], // B to D, E, F
	[6, 2], [6, 3], [6, 4], // G to C, D, E
	[7, 3], [7, 4], [7, 5], // H to D, E, F
	[2, 3], [3, 4], [4, 5]  // C-D, D-E, E-F
]

// 'isValid' checks if the pegs are a valid solution.
// If the absolute difference between any pair of connected pegs is
// greater than one it is a valid solution.
var isValid = Fn.new { |pegs|
   for (c in connections) {
       if ((pegs[c[0]] - pegs[c[1]]).abs <= 1) return false
   }
   return true
}

var swap = Fn.new { |pegs, i, j|
    var tmp = pegs[i]
    pegs[i] = pegs[j]
    pegs[j] = tmp
}

// 'solve' is a simple recursive brute force solver,
// it stops at the first found solution.
// It returns the solution, the number of positions tested,
// and the number of pegs swapped.
var solve
solve = Fn.new {
    var pegs = List.filled(8, 0)
    for (i in 0..7) pegs[i] = i + 1
    var tests = 0
    var swaps = 0

    var recurse // recursive closure
    recurse = Fn.new { |i|
        if (i >= pegs.count - 1) {
            tests = tests + 1
            return isValid.call(pegs)
        }
        // Try each remaining peg from pegs[i] onwards
        for (j in i...pegs.count) {
            swaps = swaps + 1
            swap.call(pegs, i, j)
            if (recurse.call(i + 1)) return true
            swap.call(pegs, i, j)
        }
        return false
    }

    recurse.call(0)
    return Solution.new(pegs, tests, swaps)
}

var pegsAsString = Fn.new { |pegs|
    var ca = conn.toList
    var i = 0
    for (c in ca) {
        if ("ABCDEFGH".contains(c)) ca[i] = String.fromByte(48 + pegs[c.bytes[0] - 65])
        i = i + 1
    }
    return ca.join()
}

var s = solve.call()
System.print(pegsAsString.call(s.p))
System.print("Tested %(s.tests) positions and did %(s.swaps) swaps.")
