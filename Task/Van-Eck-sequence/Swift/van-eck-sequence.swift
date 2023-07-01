struct VanEckSequence: Sequence, IteratorProtocol {
    private var index = 0
    private var lastTerm = 0
    private var lastPos = Dictionary<Int, Int>()

    mutating func next() -> Int? {
        let result = lastTerm
        var nextTerm = 0
        if let v = lastPos[lastTerm] {
            nextTerm = index - v
        }
        lastPos[lastTerm] = index
        lastTerm = nextTerm
        index += 1
        return result
    }
}

let seq = VanEckSequence().prefix(1000)

print("First 10 terms of the Van Eck sequence:")
for n in seq.prefix(10) {
    print(n, terminator: " ")
}
print("\nTerms 991 to 1000 of the Van Eck sequence:")
for n in seq.dropFirst(990) {
    print(n, terminator: " ")
}
print()
