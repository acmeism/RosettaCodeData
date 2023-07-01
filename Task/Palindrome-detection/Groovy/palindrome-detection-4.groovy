def isPalindrome
isPalindrome = { String s ->
    def n = s.size()
    n < 2 || (s[0] == s[n-1] && isPalindrome(s[1..<(n-1)]))
}
