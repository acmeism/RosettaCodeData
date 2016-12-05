def multiplier = { n1, n2 -> { m -> n1 * n2 * m } }

def ε = 0.00000001  // tolerance(epsilon): acceptable level of "wrongness" to account for rounding error
[(2.0):0.5, (4.0):0.25, (6.0):(1/6.0)].each { num, inv ->
    def new_function = multiplier(num, inv)
    (1.0..5.0).each { trial ->
        assert (new_function(trial) - trial).abs() < ε
        printf('%5.3f * %5.3f * %5.3f == %5.3f\n', num, inv, trial, trial)
    }
    println()
}
