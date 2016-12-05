Result(*Args) y3<Result, Args>(
        Result(*Args)(Result(*Args)) f)
        given Args satisfies Anything[]
    =>  flatten((Args args) => f(y3(f))(*args));
