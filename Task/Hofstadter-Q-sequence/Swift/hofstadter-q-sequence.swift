let n = 100000

var q = Array(repeating: 0, count: n)
q[0] = 1
q[1] = 1

for i in 2..<n {
    q[i] = q[i - q[i - 1]] + q[i - q[i - 2]]
}

print("First 10 elements of the sequence: \(q[0..<10])")
print("1000th element of the sequence: \(q[999])")

var count = 0
for i in 1..<n {
    if q[i] < q[i - 1] {
        count += 1
    }
}
print("Number of times a member of the sequence is less than the preceding term for terms up to and including the 100,000th term: \(count)")
