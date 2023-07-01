String encode(String string) {
    Pattern pattern = Pattern.compile("(.)\\1*");
    Matcher matcher = pattern.matcher(string);
    StringBuilder encoded = new StringBuilder();
    while (matcher.find()) {
        encoded.append(matcher.group().length());
        encoded.append(matcher.group().charAt(0));
    }
    return encoded.toString();
}
