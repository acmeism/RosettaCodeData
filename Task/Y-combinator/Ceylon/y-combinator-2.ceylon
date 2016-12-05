Result(*Args) y2<Result,Args>(
        Result(*Args)(Result(*Args)) f)
        given Args satisfies Anything[] {

    function r(Anything w) {
        assert (is Result(*Args)(Anything) w);
        return f(flatten((Args args) => w(w)(*args)));
    }

    return r(r);
}
