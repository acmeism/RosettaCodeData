int[] concat(int[] arrayA, int[] arrayB) {
    List<Integer> list = new ArrayList<>();
    for (int value : arrayA) list.add(value);
    for (int value : arrayB) list.add(value);
    int[] array = new int[list.size()];
    for (int index = 0; index < list.size(); index++)
        array[index] = list.get(index);
    return array;
}
