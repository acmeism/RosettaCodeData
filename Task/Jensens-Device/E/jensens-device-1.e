pragma.enable("one-method-object") # "def _.get" is experimental shorthand
def sum(&i, lo, hi, &term) {   # bind i and term to passed slots
    var temp := 0
    i := lo
    while (i <= hi) {          # E has numeric-range iteration but it creates a distinct
        temp += term           # variable which would not be shared with the passed i
        i += 1
    }
    return temp
}
{
    var i := null
    sum(&i, 1, 100, def _.get() { return 1/i })
}
