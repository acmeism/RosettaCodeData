public static float max(float[] values) throws NoSuchElementException {
    if (values.length == 0)
        throw new NoSuchElementException();
    float themax = values[0];
    for (int idx = 1; idx < values.length; ++idx) {
        if (values[idx] > themax)
            themax = values[idx];
    }
    return themax;
}
