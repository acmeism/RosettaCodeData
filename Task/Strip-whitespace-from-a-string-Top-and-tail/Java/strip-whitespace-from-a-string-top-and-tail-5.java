String removeLeading(String string, char[] characters) {
    int index = 0;
    for (char characterA : string.toCharArray()) {
        for (char characterB : characters) {
            if (characterA != characterB)
                return string.substring(index);
        }
        index++;
    }
    return string;
}
