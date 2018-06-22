func A(_ k: Int,
       _ x1: @escaping () -> Int,
       _ x2: @escaping () -> Int,
       _ x3: @escaping () -> Int,
       _ x4: @escaping () -> Int,
       _ x5: @escaping () -> Int) -> Int {
    var k1 = k

    func B() -> Int {
        k1 -= 1
        return A(k1, B, x1, x2, x3, x4)
    }

    if k1 <= 0 {
        return x4() + x5()
    } else {
        return B()
    }
}

print(A(10, {1}, {-1}, {-1}, {1}, {0}))
