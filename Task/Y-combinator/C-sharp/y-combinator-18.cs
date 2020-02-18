    public static Func<A, B> Y<A, B>(Func<Func<A, B>, Func<A, B>> f) {
        Func<dynamic, Func<A, B>> r = z => { var w = (Func<dynamic, Func<A, B>>)z; return f(_0 => w(w)(_0)); };
        return r(r);
    }
