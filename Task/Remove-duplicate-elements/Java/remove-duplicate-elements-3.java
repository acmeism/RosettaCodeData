int[] removeDuplicates(int[] values) {
    List<Integer> list = new ArrayList<>();
    for (int value : values)
        if (!list.contains(value)) list.add(value);
    values = new int[list.size()];
    int index = 0;
    for (int value : list)
        values[index++] = value;
    return values;
}
