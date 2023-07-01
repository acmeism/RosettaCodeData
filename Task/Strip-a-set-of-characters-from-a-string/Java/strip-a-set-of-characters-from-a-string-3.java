static String stripCharacters(String string, String characters) {
    /* be sure to 'quote' the 'characters' to avoid pattern collision */
    characters = Pattern.quote(characters);
    string = string.replaceAll("[%s]".formatted(characters), "");
    return string;
}
