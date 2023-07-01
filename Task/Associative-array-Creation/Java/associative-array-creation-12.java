Comparator<String> comparator = (stringA, stringB) -> {
    if (stringA.compareTo(stringB) > 0) {
        return -1;
    } else if (stringA.compareTo(stringB) < 0) {
        return 1;
    }
    return 0;
};
