func rlcs(s1:String, _ s2:String) -> String {
    let x = s1.characters.count
    let y = s2.characters.count

    if x == 0 || y == 0 {
        return ""
    } else if s1[s1.startIndex.advancedBy(x - 1)] == s2[s2.startIndex.advancedBy(y - 1)] {
        return rlcs(s1[s1.startIndex..<s1.startIndex.advancedBy(x - 1)],
            s2[s2.startIndex..<s2.startIndex.advancedBy(y - 1)]) + String(s1[s1.startIndex.advancedBy(x - 1)])
    } else {
        let xstr = rlcs(s1, s2[s2.startIndex..<s2.startIndex.advancedBy(y - 1)])
        let ystr = rlcs(s1[s1.startIndex..<s1.startIndex.advancedBy(x - 1)], s2)

        return xstr.characters.count > ystr.characters.count ? xstr : ystr
    }
}
