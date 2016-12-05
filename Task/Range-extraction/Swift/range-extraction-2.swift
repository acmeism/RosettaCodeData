extension NSIndexSet {

    var rangesDescription : String {
        var out = ""
        indexSet.enumerateRangesUsingBlock { range, _ in
            let start = range.location
            let end = range.location+range.length-1
            out += out.isEmpty ? "" : ","
            if start == end {
                out += "\(start)"
            }
            else if end == start + 1 {
                out += "\(start),\(end)"
            }
            else {
                out += "\(start)-\(end)"
            }
        }
        return out
    }
}

let ex = [-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20]
let longer = [0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
    25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
    37, 38, 39]

var indexSet = NSMutableIndexSet()
ex.map { indexSet.addIndex($0) }
indexSet.rangesDescription

var indexSet2 = NSMutableIndexSet()
longer.map { indexSet2.addIndex($0) }
indexSet2.rangesDescription
