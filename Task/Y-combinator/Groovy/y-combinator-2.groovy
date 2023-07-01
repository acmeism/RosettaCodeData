def Y = { le -> ({ f -> f(f) })({ f -> le { Object[] args -> f(f)(*args) } }) }

def mul = Y { mulStar -> { a, b -> a ? b + mulStar(a - 1, b) : 0 } }

1.upto(10) {
    assert mul(it, 10) == it * 10
}
