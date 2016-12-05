import func Darwin.arc4random_uniform

func shuffleInPlace<T: MutableCollectionType where T.Index: RandomAccessIndexType>(inout collection: T) {

    let i0 = collection.startIndex

    for i in i0.successor() ..< collection.endIndex {

        let j = i0.advancedBy(numericCast(
                    arc4random_uniform(numericCast(
                        i0.distanceTo()
                    )+1)
                ))

        swap(&collection[i], &collection[j])
    }
}

func shuffle<T: MutableCollectionType where T.Index: RandomAccessIndexType>(collection: T) -> T {

    var result = collection

    shuffleInPlace(&result)

    return result
}

// Swift 2.0:
print(shuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]))
// Swift 1.x:
//println(shuffle([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]))
