public static void main(String[] args) {
    String[] strings = {
        "", "   ", "2", "333", ".55", "tttTTT", "5", "4444 444k"
    };
    for (String string : strings)
        System.out.println(printCompare(string));
}

static String printCompare(String string) {
    String stringA = "'%s' %d".formatted(string, string.length());
    Pattern pattern = Pattern.compile("(.)\\1*");
    Matcher matcher = pattern.matcher(string);
    StringBuilder stringB = new StringBuilder();
    /* 'Matcher' works dynamically, so we'll have to denote a change */
    boolean difference = false;
    char character;
    String newline = System.lineSeparator();
    while (matcher.find()) {
        if (matcher.start() != 0) {
            character = matcher.group(1).charAt(0);
            stringB.append(newline);
            stringB.append("  Char '%s' (0x%x)".formatted(character, (int) character));
            stringB.append(" @ index %d".formatted(matcher.start()));
            difference = true;
        }
    }
    if (!difference)
        stringB.append(newline).append("  All characters are the same");
    return stringA + stringB;
}
