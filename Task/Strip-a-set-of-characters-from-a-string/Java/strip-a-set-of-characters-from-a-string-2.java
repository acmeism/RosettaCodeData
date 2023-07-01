String stripCharacters(String string, String characters) {
    StringBuilder stripped = new StringBuilder(string);
    /* traversing the string backwards is necessary to avoid collision */
    for (int index = string.length() - 1; index >= 0; index--) {
        if (characters.contains(String.valueOf(string.charAt(index))))
            stripped.deleteCharAt(index);
    }
    return stripped.toString();
}
