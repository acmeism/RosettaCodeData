    public static <A,B> Function<A,B> Y(Function<Function<A,B>, Function<A,B>> f) {
        return x -> f.apply(Y(f)).apply(x);
    }
