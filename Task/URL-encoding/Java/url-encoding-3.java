String encode(String string) {
    StringBuilder encoded = new StringBuilder();
    for (char character : string.toCharArray()) {
        switch (character) {
            /* rfc3986 and html5 */
            case '-', '.', '_', '~', '*' -> encoded.append(character);
            case ' ' -> encoded.append('+');
            default -> {
                if (alphanumeric(character))
                    encoded.append(character);
                else {
                    encoded.append("%");
                    encoded.append("%02x".formatted((int) character));
                }
            }
        }
    }
    return encoded.toString();
}

boolean alphanumeric(char character) {
    return (character >= 'A' && character <= 'Z')
        || (character >= 'a' && character <= 'z')
        || (character >= '0' && character <= '9');
}
