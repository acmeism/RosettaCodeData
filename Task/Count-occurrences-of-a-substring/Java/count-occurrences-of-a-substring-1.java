int countSubstring(String string, String substring) {
    substring = Pattern.quote(substring);
    Pattern pattern = Pattern.compile(substring);
    Matcher matcher = pattern.matcher(string);
    int count = 0;
    while (matcher.find())
        count++;
    return count;
}
