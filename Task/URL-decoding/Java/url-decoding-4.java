String decode(String string) {
    Pattern pattern = Pattern.compile("%([A-Za-z\\d]{2})");
    Matcher matcher = pattern.matcher(string);
    StringBuilder decoded = new StringBuilder(string);
    char character;
    int start, end, offset = 0;
    while (matcher.find()) {
        character = (char) Integer.parseInt(matcher.group(1), 16);
        /* offset the matched index since were adjusting the string */
        start = matcher.start() - offset;
        end = matcher.end() - offset;
        decoded.replace(start, end, String.valueOf(character));
        offset += 2;
    }
    return decoded.toString();
}
