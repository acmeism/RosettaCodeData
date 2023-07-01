@FunctionalInterface
interface MedianFinder<T, R> extends Function<Collection<T>, R> {
    @Override
    R apply(Collection<T> data);
}

class MedianFinderImpl<T, R> implements MedianFinder<T, R> {
    private final Supplier<R> ifEmpty;
    private final Function<T, R> ifOdd;
    private final Function<List<T>, R> ifEven;

    MedianFinderImpl(Supplier<R> ifEmpty, Function<T, R> ifOdd, Function<List<T>, R> ifEven) {
        this.ifEmpty = ifEmpty;
        this.ifOdd = ifOdd;
        this.ifEven = ifEven;
    }

    @Override
    public R apply(Collection<T> data) {
        return Objects.requireNonNull(data, "data must not be null").isEmpty()
                ? ifEmpty.get()
                : (data.size() & 1) == 0
                    ? ifEven.apply(data.stream().sorted()
                          .skip(data.size() / 2 - 1)
                          .limit(2).toList())
                    : ifOdd.apply(data.stream().sorted()
                          .skip(data.size() / 2)
                          .limit(1).findFirst().get());
    }
}

public class MedianOf {
    private static final MedianFinder<Integer, Integer> INTEGERS = new MedianFinderImpl<>(() -> 0, n -> n, pair -> (pair.get(0) + pair.get(1)) / 2);
    private static final MedianFinder<Integer, Float> INTEGERS_AS_FLOAT = new MedianFinderImpl<>(() -> 0f, n -> n * 1f, pair -> (pair.get(0) + pair.get(1)) / 2f);
    private static final MedianFinder<Integer, Double> INTEGERS_AS_DOUBLE = new MedianFinderImpl<>(() -> 0d, n -> n * 1d, pair -> (pair.get(0) + pair.get(1)) / 2d);
    private static final MedianFinder<Float, Float> FLOATS = new MedianFinderImpl<>(() -> 0f, n -> n, pair -> (pair.get(0) + pair.get(1)) / 2);
    private static final MedianFinder<Double, Double> DOUBLES = new MedianFinderImpl<>(() -> 0d, n -> n, pair -> (pair.get(0) + pair.get(1)) / 2);
    private static final MedianFinder<BigInteger, BigInteger> BIG_INTEGERS = new MedianFinderImpl<>(() -> BigInteger.ZERO, n -> n, pair -> pair.get(0).add(pair.get(1)).divide(BigInteger.TWO));
    private static final MedianFinder<BigInteger, BigDecimal> BIG_INTEGERS_AS_BIG_DECIMAL = new MedianFinderImpl<>(() -> BigDecimal.ZERO, BigDecimal::new, pair -> new BigDecimal(pair.get(0).add(pair.get(1))).divide(BigDecimal.valueOf(2), RoundingMode.FLOOR));
    private static final MedianFinder<BigDecimal, BigDecimal> BIG_DECIMALS = new MedianFinderImpl<>(() -> BigDecimal.ZERO, n -> n, pair -> pair.get(0).add(pair.get(1)).divide(BigDecimal.valueOf(2), RoundingMode.FLOOR));

    public static Integer    integers(Collection<Integer> integerCollection) { return INTEGERS.apply(integerCollection); }
    public static Float      integersAsFloat(Collection<Integer> integerCollection) { return INTEGERS_AS_FLOAT.apply(integerCollection); }
    public static Double     integersAsDouble(Collection<Integer> integerCollection) { return INTEGERS_AS_DOUBLE.apply(integerCollection); }
    public static Float      floats(Collection<Float> floatCollection) { return FLOATS.apply(floatCollection); }
    public static Double     doubles(Collection<Double> doubleCollection) { return DOUBLES.apply(doubleCollection); }
    public static BigInteger bigIntegers(Collection<BigInteger> bigIntegerCollection) { return BIG_INTEGERS.apply(bigIntegerCollection); }
    public static BigDecimal bigIntegersAsBigDecimal(Collection<BigInteger> bigIntegerCollection) { return BIG_INTEGERS_AS_BIG_DECIMAL.apply(bigIntegerCollection); }
    public static BigDecimal bigDecimals(Collection<BigDecimal> bigDecimalCollection) { return BIG_DECIMALS.apply(bigDecimalCollection); }
}
