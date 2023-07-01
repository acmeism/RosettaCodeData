boolean isAscending(String[] strings) {
    String previous = strings[0];
    int index = 0;
    for (String string : strings) {
        if (index++ == 0)
            continue;
        if (string.compareTo(previous) < 0)
            return false;
        previous = string;
    }
    return true;
}
