func isPalindrome(s string) bool {
	runes := []rune(s)
	numRunes := len(runes) - 1
	for i := 0; i < len(runes)/2; i++ {
		if runes[i] != runes[numRunes-i] {
			return false
		}
	}
	return true
}
