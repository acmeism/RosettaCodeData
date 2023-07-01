String removeTrailing(String string, char[] characters) {
    for (int index = string.length() - 1; index >= 0; index--) {
        for (char character : characters) {
            if (string.charAt(index) != character)
                return string.substring(0, index + 1);
        }
    }
    return string;
}
