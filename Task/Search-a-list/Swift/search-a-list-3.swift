// the second part can be done several ways, but extending any Array of Comparable objects is the most generic approach
extension Array where Element : Comparable {
    func lastIndexMatching(needle:Element) -> Int? {

        for i in stride(from: count-1, through: 0, by: -1) {
            if self[i] == needle {
                return i
            }
        }
        return nil
    }
}

for needle in ["Washington","Bush"] {
    if let index = haystack.lastIndexMatching(needle) {
        print("\(index) \(needle)")
    } else {
        print("\(needle) is not in haystack")
    }
}
