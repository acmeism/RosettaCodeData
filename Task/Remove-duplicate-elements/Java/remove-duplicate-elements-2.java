int[] removeDuplicates(int[] values) {
    /* use a LinkedHashSet to preserve order */
    Set<Integer> set = new LinkedHashSet<>();
    for (int value : values)
        set.add(value);
    values = new int[set.size()];
    Iterator<Integer> iterator = set.iterator();
    int index = 0;
    while (iterator.hasNext())
        values[index++] = iterator.next();
    return values;
}
