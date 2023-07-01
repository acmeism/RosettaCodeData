// Implementation of Heap's algorithm.
// See https://en.wikipedia.org/wiki/Heap%27s_algorithm#Details_of_the_algorithm
func generate<T>(array: inout [T], output: (_: [T], _: Int) -> Void) {
    let n = array.count
    var c = Array(repeating: 0, count: n)
    var i = 1
    var sign = 1
    output(array, sign)
    while i < n {
        if c[i] < i {
            if (i & 1) == 0 {
                array.swapAt(0, i)
            } else {
                array.swapAt(c[i], i)
            }
            sign = -sign
            output(array, sign)
            c[i] += 1
            i = 1
        } else {
            c[i] = 0
            i += 1
        }
    }
}

func printPermutation<T>(array: [T], sign: Int) {
    print("\(array) \(sign)")
}

print("Permutations and signs for three items:")
var a = [0, 1, 2]
generate(array: &a, output: printPermutation)

print("\nPermutations and signs for four items:")
var b = [0, 1, 2, 3]
generate(array: &b, output: printPermutation)
