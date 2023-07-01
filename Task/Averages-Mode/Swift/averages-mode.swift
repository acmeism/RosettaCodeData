// Extend the Collection protocol. Any type that conforms to extension where its Element type conforms to Hashable will automatically gain this method.
extension Collection where Element: Hashable {

    /// Return a Mode of the function, or nil if none exist.
    func mode() -> Element? {
        var frequencies = [Element: Int]()

        // Standard for loop. Can also use the forEach(_:) or reduce(into:) methods on self.
        for element in self {
            frequencies[element] = (frequencies[element] ?? 0) + 1
        }

        // The max(by:) method used here to find one of the elements with the highest associated count.
        if let ( mode, _ ) = frequencies.max(by: { $0.value < $1.value }) {
            return mode
        } else {
            return nil
        }
    }

}

["q", "a", "a", "a", "a", "b", "b", "z", "c", "c", "c"].mode() // returns "a"
[1, 1, 2, 3, 3, 3, 3, 4, 4, 4].mode() // returns 3

let emptyArray: [Int] = []
emptyArray.mode() // returns nil
