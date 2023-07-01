public static boolean isPalindrome(String input) {
	for (int i = 0, j = input.length() - 1; i < j; i++, j--) {
		char startChar = input.charAt(i);
		char endChar = input.charAt(j);

		// Handle surrogate pairs in UTF-16
		if (Character.isLowSurrogate(endChar)) {
			if (startChar != input.charAt(--j)) {
				return false;
			}
			if (input.charAt(++i) != endChar) {
				return false;
			}
		} else if (startChar != endChar) {
			return false;
		}
	}
	return true;
}
