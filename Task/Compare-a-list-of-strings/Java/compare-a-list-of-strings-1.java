boolean allEqual(String[] strings) {
    String stringA = strings[0];
    for (String string : strings) {
        if (!string.equals(stringA))
            return false;
    }
    return true;
}
