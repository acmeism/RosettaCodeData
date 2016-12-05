func lcs(s1:String, _ s2:String) -> String {
    var x = s1.characters.count
    var y = s2.characters.count
    var lens = Array(count: x + 1, repeatedValue:
        Array(count: y + 1, repeatedValue: 0))
    var returnStr = ""

    for i in 0..<x {
        for j in 0..<y {
            if s1[s1.startIndex.advancedBy(i)] == s2[s2.startIndex.advancedBy(j)] {
                lens[i + 1][j + 1] = lens[i][j] + 1
            } else {
                lens[i + 1][j + 1] = max(lens[i + 1][j], lens[i][j + 1])
            }
        }
    }

    while x != 0 && y != 0 {
        if lens[x][y] == lens[x - 1][y] {
            --x
        } else if lens[x][y] == lens[x][y - 1] {
            --y
        } else {
            returnStr += String(s1[s1.startIndex.advancedBy(x - 1)])
            --x
            --y
        }
    }

    return String(returnStr.characters.reverse())
}
