<X, Y, Z> Function<Y, Z> exampleA(BiFunction<X, Y, Z> exampleB, X value) {
    return y -> exampleB.apply(value, y);
}
