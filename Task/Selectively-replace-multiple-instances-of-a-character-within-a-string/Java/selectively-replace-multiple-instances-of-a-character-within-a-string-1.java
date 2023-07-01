int findNth(String s, char c, int n) {
    if (n == 1) return s.indexOf(c);
    return s.indexOf(c, findNth(s, c, n - 1) + 1);
}

String selectiveReplace(String s, Set... ops) {
    char[] chars = s.toCharArray();
    for (Set set : ops)
        chars[findNth(s, set.old, set.n)] = set.rep;
    return new String(chars);
}

record Set(int n, char old, char rep) { }
