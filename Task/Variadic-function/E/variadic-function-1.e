def example {
    match [`run`, args] {
        for x in args {
            println(x)
        }
    }
}

example("Mary", "had", "a", "little", "lamb")

E.call(example, "run", ["Mary", "had", "a", "little", "lamb"])
