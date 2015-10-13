    public static void sortByName(Pair[] pairs) {
        Arrays.sort(pairs, (p1, p2) -> p1.name.compareTo(p2.name));
    }
