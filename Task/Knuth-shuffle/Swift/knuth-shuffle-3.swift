import func Darwin.arc4random_uniform

// Define a protocol for shuffling:

protocol Shufflable {

    @warn_unused_result (mutable_variant="shuffleInPlace")
    func shuffle() -> Self

    mutating func shuffleInPlace()

}

// Provide a generalized implementation of the shuffling protocol for any mutable collection with random-access index:

extension Shufflable where Self: MutableCollectionType, Self.Index: RandomAccessIndexType {

    func shuffle() -> Self {

        var result = self

        result.shuffleInPlace()

        return result
    }

    mutating func shuffleInPlace() {

        let i0 = startIndex

        for i in i0+1 ..< endIndex {

            let j = i0.advancedBy(numericCast(
                        arc4random_uniform(numericCast(
                            i0.distanceTo(i)
                        )+1)
                    ))

            swap(&self[i], &self[j])
        }
    }

}

// Declare Array's conformance to Shufflable:

extension Array: Shufflable
    { /* Implementation provided by Shufflable protocol extension */ }

print([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].shuffle())
