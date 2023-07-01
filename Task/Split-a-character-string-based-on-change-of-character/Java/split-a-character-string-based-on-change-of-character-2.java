String split(String string) {
    Pattern pattern = Pattern.compile("(.)\\1*");
    Matcher matcher = pattern.matcher(string);
    StringBuilder strings = new StringBuilder();
    int index = 0;
    while (matcher.find()) {
        if (index++ != 0)
            strings.append(", ");
        strings.append(matcher.group());
    }
    return strings.toString();
}
