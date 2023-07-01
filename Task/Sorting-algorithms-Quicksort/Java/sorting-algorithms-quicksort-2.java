public static <E extends Comparable<E>> List<E> sort(List<E> col) {
    if (col == null || col.isEmpty())
        return Collections.emptyList();
    else {
        E pivot = col.get(0);
        Map<Integer, List<E>> grouped = col.stream()
                .collect(Collectors.groupingBy(pivot::compareTo));
        return Stream.of(sort(grouped.get(1)), grouped.get(0), sort(grouped.get(-1)))
                .flatMap(Collection::stream).collect(Collectors.toList());
    }
}
