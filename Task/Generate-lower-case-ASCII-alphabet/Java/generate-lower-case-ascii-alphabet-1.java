char[] lowerAlphabet() {
    char[] letters = new char[26];
    for (int code = 97; code < 123; code++)
        letters[code - 97] = (char) code;
    return letters;
}
