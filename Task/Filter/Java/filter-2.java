public static <T> T[] filter(T[] input, Predicate<T> filterMethod) {
    return Arrays.stream(input)
        .filter(filterMethod)
        .toArray(size -> (T[]) Array.newInstance(input.getClass().getComponentType(), size));
}
