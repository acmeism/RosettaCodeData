    public static void sortByName(Pair[] pairs) {
        Arrays.sort(pairs, Comparator.comparing(p -> p.name));
    }
