func rangesFromInts(ints:[Int]) -> [(Int, Int)] {

    var range : (Int, Int)?
    var ranges = [(Int, Int)]()
    for this in ints {
        if let (start, end) = range {
            if this == end + 1 {
                range = (start, this)
            }
            else {
                ranges.append(range!)
                range = (this, this)
            }
        }
        else { range = (this, this) }
    }
    ranges.append(range!)

    return ranges
}

func descriptionFromRanges(ranges:[(Int, Int)]) -> String {
    var desc = ""
    for (start, end) in ranges {
        desc += desc.isEmpty ? "" : ","
        if start == end {
            desc += "\(start)"
        }
        else if end == start + 1 {
            desc += "\(start),\(end)"
        }
        else {
            desc += "\(start)-\(end)"
        }
    }
    return desc
}


let ex = [-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20]
let longer = [0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
    25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
    37, 38, 39]

descriptionFromRanges(rangesFromInts(ex))
descriptionFromRanges(rangesFromInts(longer))
