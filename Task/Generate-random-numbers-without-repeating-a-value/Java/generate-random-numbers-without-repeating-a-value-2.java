int[] randomList() {
    /* 'Set' allows only unique values */
    /* 'LinkedHashSet' will preserve the input order */
    Set<Integer> set = new LinkedHashSet<>();
    Random random = new Random();
    while (set.size() < 20)
        set.add(random.nextInt(1, 21));
    int[] values = new int[set.size()];
    /* 'Set' does not have a 'get' method */
    Iterator<Integer> iterator = set.iterator();
    int index = 0;
    while (iterator.hasNext())
        values[index++] = iterator.next();
    return values;
}
