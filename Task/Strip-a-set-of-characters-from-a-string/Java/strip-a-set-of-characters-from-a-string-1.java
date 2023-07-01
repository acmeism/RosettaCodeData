String stripCharacters(String string, String characters) {
    for (char character : characters.toCharArray())
        string = string.replace(String.valueOf(character), "");
    return string;
}
