import Foundation

func loadDictionary(_ path: String) throws -> [String] {
    let contents = try String(contentsOfFile: path, encoding: String.Encoding.ascii)
    return contents.components(separatedBy: "\n")
}

func jaroWinklerDistance(string1: String, string2: String) -> Double {
    var st1 = Array(string1)
    var st2 = Array(string2)
    var len1 = st1.count
    var len2 = st2.count
    if len1 < len2 {
        swap(&st1, &st2)
        swap(&len1, &len2)
    }
    if len2 == 0 {
        return len1 == 0 ? 0.0 : 1.0
    }
    let delta = max(1, len1 / 2) - 1
    var flag = Array(repeating: false, count: len2)
    var ch1Match: [Character] = []
    ch1Match.reserveCapacity(len1)
    for idx1 in 0..<len1 {
        let ch1 = st1[idx1]
        for idx2 in 0..<len2 {
            let ch2 = st2[idx2]
            if idx2 <= idx1 + delta && idx2 + delta >= idx1 && ch1 == ch2 && !flag[idx2] {
                flag[idx2] = true
                ch1Match.append(ch1)
                break
            }
        }
    }
    let matches = ch1Match.count
    if matches == 0 {
        return 1.0
    }
    var transpositions = 0
    var idx1 = 0
    for idx2 in 0..<len2 {
        if flag[idx2] {
            if st2[idx2] != ch1Match[idx1] {
                transpositions += 1
            }
            idx1 += 1
        }
    }
    let m = Double(matches)
    let jaro =
        (m / Double(len1) + m / Double(len2) + (m - Double(transpositions) / 2.0) / m) / 3.0
    var commonPrefix = 0
    for i in 0..<min(4, len2) {
        if st1[i] == st2[i] {
            commonPrefix += 1
        }
    }
    return 1.0 - (jaro + Double(commonPrefix) * 0.1 * (1.0 - jaro))
}

func withinDistance(words: [String], maxDistance: Double, string: String,
                    maxToReturn: Int) -> [(String, Double)] {
    var arr = Array(words.map{($0, jaroWinklerDistance(string1: string, string2: $0))}
        .filter{$0.1 <= maxDistance})
    arr.sort(by: { x, y in return x.1 < y.1 })
    return Array(arr[0..<min(maxToReturn, arr.count)])
}

func pad(string: String, width: Int) -> String {
    if string.count >= width {
        return string
    }
    return String(repeating: " ", count: width - string.count) + string
}

do {
    let dict = try loadDictionary("linuxwords.txt")
    for word in ["accomodate", "definately", "goverment", "occured",
                 "publically", "recieve", "seperate", "untill", "wich"] {
        print("Close dictionary words (distance < 0.15 using Jaro-Winkler distance) to '\(word)' are:")
        print("        Word   |  Distance")
        for (w, dist) in withinDistance(words: dict, maxDistance: 0.15,
                                        string: word, maxToReturn: 5) {
            print("\(pad(string: w, width: 14)) | \(String(format: "%6.4f", dist))")
        }
        print()
    }
} catch {
    print(error.localizedDescription)
}
