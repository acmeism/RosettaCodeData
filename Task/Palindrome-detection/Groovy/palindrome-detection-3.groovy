def isPalindrome = { String s ->
    def n = s.size()
    n < 2 || s[0..<n/2] == s[-1..(-n/2)]
}
