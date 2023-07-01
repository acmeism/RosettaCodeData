func lcs(_ s1: String, _ s2: String) -> String {
    var lens = Array(
        repeating:Array(repeating: 0, count: s2.count + 1),
        count: s1.count + 1
    )

    for i in 0..<s1.count {
        for j in 0..<s2.count {
            if s1[s1.index(s1.startIndex, offsetBy: i)] == s2[s2.index(s2.startIndex, offsetBy: j)] {
                lens[i + 1][j + 1] = lens[i][j] + 1
            } else {
                lens[i + 1][j + 1] = max(lens[i + 1][j], lens[i][j + 1])
            }
        }
    }

    var returnStr = ""
    var x = s1.count
    var y = s2.count
    while x != 0 && y != 0 {
        if lens[x][y] == lens[x - 1][y] {
            x -= 1
        } else if lens[x][y] == lens[x][y - 1] {
            y -= 1
        } else {
            returnStr += String(s1[s1.index(s1.startIndex, offsetBy:  x - 1)])
            x -= 1
            y -= 1
        }
    }

    return String(returnStr.reversed())
}
