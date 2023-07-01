import func Darwin.arc4random_uniform

extension Array {

    func shuffle() -> Array {

        var result = self; result.shuffleInPlace(); return result
    }

    mutating func shuffleInPlace() {

        for i in 1 ..< count { swap(&self[i], &self[Int(arc4random_uniform(UInt32(i+1)))]) }
    }

}

// Swift 2.0:
print([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].shuffle())
// Swift 1.x:
//println([1, 2, 3, 4, 5, 6, 7, 8, 9, 10].shuffle())
