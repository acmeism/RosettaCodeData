var findCommonDir = Fn.new { |paths, sep|
    var count = paths.count
    if (count == 0) return ""
    if (count == 1) return paths[0]
    var splits = List.filled(count, null)
    for (i in 0...count) splits[i] = paths[i].split(sep)
    var minLen = splits[0].count
    for (i in 1...count) {
        var c = splits[i].count
        if (c < minLen) minLen = c
    }
    if (minLen < 2) return ""
    var common = ""
    for (i in 1...minLen) {
        var dir = splits[0][i]
        for (j in 1...count) {
            if (splits[j][i] != dir) return common
        }
        common = common + sep + dir
    }
    return common
}

var paths = [
    "/home/user1/tmp/coverage/test",
    "/home/user1/tmp/covert/operator",
    "/home/user1/tmp/coven/members"
]
System.write("The common directory path is: ")
System.print(findCommonDir.call(paths, "/"))
