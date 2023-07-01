String decode(String string) {
    Pattern pattern = Pattern.compile("(\\d+)(.)");
    Matcher matcher = pattern.matcher(string);
    StringBuilder decoded = new StringBuilder();
    int count;
    while (matcher.find()) {
        count = Integer.parseInt(matcher.group(1));
        decoded.append(matcher.group(2).repeat(count));
    }
    return decoded.toString();
}
