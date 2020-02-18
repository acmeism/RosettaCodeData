    static Func Y(FuncFunc f) {
        return delegate (int x) {
            return f(Y(f))(x);
        };
    }
