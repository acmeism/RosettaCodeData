func maxSubseq(sequence: [Int]) -> (Int, Int, Int) {
    var maxSum = 0, thisSum = 0, i = 0
    var start = 0, end = -1
    for (j, seq) in sequence.enumerated() {
        thisSum += seq
        if thisSum < 0 {
            i = j + 1
            thisSum = 0
        } else if (thisSum > maxSum) {
            maxSum = thisSum
            start = i
            end = j
        }
    }
    return start <= end && start >= 0 && end >= 0
        ? (start, end + 1, maxSum) : (0, 0, 0)
}

let a = [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1]
let (start, end, maxSum) = maxSubseq(sequence: a)
print("Max sum = \(maxSum)")
print(a[start..<end])
