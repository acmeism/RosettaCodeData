def dividesByZero = { double n, double d ->
    assert ! n.infinite : 'Algorithm fails if the numerator is already infinite.'
    (n/d).infinite || (n/d).naN
}
