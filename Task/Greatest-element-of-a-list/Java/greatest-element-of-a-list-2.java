public static float max(float[] values) throws NoSuchElementException {
    if (values.length == 0)
        throw new NoSuchElementException();
    Arrays.sort(values);//sorts the values in ascending order
    return values[values.length-1];
}
