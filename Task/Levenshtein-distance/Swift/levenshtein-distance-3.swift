func levenshteinDistance(string1: String, string2: String) -> Int {
    let m = string1.count
    let n = string2.count
    if m == 0 {
        return n
    }
    if n == 0 {
        return m
    }
    var costs = Array(0...n)
    for (i, c1) in string1.enumerated() {
        costs[0] = i + 1
        var corner = i
        for (j, c2) in string2.enumerated() {
            let upper = costs[j + 1]
            if c1 == c2 {
                costs[j + 1] = corner
            } else {
                costs[j + 1] = 1 + min(costs[j], upper, corner)
            }
            corner = upper
        }
    }
    return costs[n]
}

print(levenshteinDistance(string1: "rosettacode", string2: "raisethysword"))
