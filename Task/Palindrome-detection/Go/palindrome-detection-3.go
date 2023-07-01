func isPalindrome(s string) bool {
	runes := []rune(s)
	for len(runes) > 1 {
		if runes[0] != runes[len(runes)-1] {
			return false
		}
		runes = runes[1 : len(runes)-1]
	}
	return true
}
