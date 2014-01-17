def a; a = { k, x1, x2, x3, x4, x5 ->
    def b; b = {
        a (--k, b, x1, x2, x3, x4)
    }
    k <= 0 ? x4() + x5() : b()
}

def x = { n -> { it -> n } }
