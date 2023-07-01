int[] concat(int[] arrayA, int[] arrayB) {
    int[] array = new int[arrayA.length + arrayB.length];
    System.arraycopy(arrayA, 0, array, 0, arrayA.length);
    System.arraycopy(arrayB, 0, array, arrayA.length, arrayB.length);
    return array;
}
