def compose(f, g) {
    return fn x { f(g(x)) }
}
