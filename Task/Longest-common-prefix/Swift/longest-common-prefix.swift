func commonPrefix(string1: String, string2: String) -> String {
    return String(zip(string1, string2).prefix(while: {$0 == $1}).map{$0.0})
}

func longestCommonPrefix(_ strings: [String]) -> String {
    switch (strings.count) {
    case 0:
        return ""
    case 1:
        return strings[0]
    default:
        return commonPrefix(string1: strings.min()!, string2: strings.max()!)
    }
}

func printLongestCommonPrefix(_ strings: [String]) {
    print("lcp(\(strings)) = \"\(longestCommonPrefix(strings))\"")
}

printLongestCommonPrefix(["interspecies", "interstellar", "interstate"])
printLongestCommonPrefix(["throne", "throne"])
printLongestCommonPrefix(["throne", "dungeon"])
printLongestCommonPrefix(["throne", "", "throne"])
printLongestCommonPrefix(["cheese"])
printLongestCommonPrefix([""])
printLongestCommonPrefix([])
printLongestCommonPrefix(["prefix", "suffix"])
printLongestCommonPrefix(["foo", "foobar"])
