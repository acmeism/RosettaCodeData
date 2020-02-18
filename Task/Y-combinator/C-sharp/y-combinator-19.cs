    public static Func<In, Out> Y<In, Out>(Func<Func<In, Out>, Func<In, Out>> f) {
        return x => f(Y(f))(x);
    }
