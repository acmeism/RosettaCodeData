    public static <A,B> Function<A,B> Y(Function<Function<A,B>, Function<A,B>> f) {
        return new Function<A,B>() {
	    public B apply(A x) {
		return f.apply(this).apply(x);
	    }
	};
    }
