assert "abcd".startsWith("ab")
assert ! "abcd".startsWith("zn")
assert "abcd".endsWith("cd")
assert ! "abcd".endsWith("zn")
assert "abab".contains("ba")
assert ! "abab".contains("bb")


assert "abab".indexOf("bb") == -1 // not found flag
assert "abab".indexOf("ab") == 0

def indicesOf = { string, substring ->
    if (!string) { return [] }
    def indices = [-1]
    while (true) {
        indices << string.indexOf(substring, indices.last()+1)
        if (indices.last() == -1) break
    }
    indices[1..<(indices.size()-1)]
}
assert indicesOf("abab", "ab") == [0, 2]
assert indicesOf("abab", "ba") == [1]
assert indicesOf("abab", "xy") == []
