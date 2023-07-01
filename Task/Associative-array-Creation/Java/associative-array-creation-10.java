Comparator<String> comparator = new Comparator<String>() {
    public int compare(String stringA, String stringB) {
        if (stringA.compareTo(stringB) > 0) {
            return -1;
        } else if (stringA.compareTo(stringB) < 0) {
            return 1;
        }
        return 0;
    }
};
