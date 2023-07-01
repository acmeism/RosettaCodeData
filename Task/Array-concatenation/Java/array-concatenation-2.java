int[] concat(int[] arrayA, int[] arrayB) {
    int[] array = new int[arrayA.length + arrayB.length];
    for (int index = 0; index < arrayA.length; index++)
        array[index] = arrayA[index];
    for (int index = 0; index < arrayB.length; index++)
        array[index + arrayA.length] = arrayB[index];
    return array;
}
