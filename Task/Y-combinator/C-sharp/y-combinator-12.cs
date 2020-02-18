    static Func Y(FuncFunc f) => x => f(Y(f))(x);
