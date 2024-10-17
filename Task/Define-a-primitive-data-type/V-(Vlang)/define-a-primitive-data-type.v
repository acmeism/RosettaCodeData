type TinyInt = int

fn new_tiny_int(i int) TinyInt {
    if i < 1 {return TinyInt(1)}
    if i > 10 {return TinyInt(10)}
    return TinyInt(i)
}

fn (t1 TinyInt) add(t2 TinyInt) TinyInt {
    return new_tiny_int(int(t1) + int(t2))
}

fn (t1 TinyInt) sub(t2 TinyInt) TinyInt {
    return new_tiny_int(int(t1) - int(t2))
}

fn (t1 TinyInt) mul(t2 TinyInt) TinyInt {
    return new_tiny_int(int(t1) * int(t2))
}

fn (t1 TinyInt) div(t2 TinyInt) TinyInt {
    return new_tiny_int(int(t1) / int(t2))
}

fn main() {
    t1 := new_tiny_int(6)
    t2 := new_tiny_int(3)
    println("t1      = ${t1}")
    println("t2      = ${t2}")
    println("t1 + t2 = ${t1.add(t2)}")
    println("t1 - t2 = ${t1.sub(t2)}")
    println("t1 * t2 = ${t1.mul(t2)}")
    println("t1 / t2 = ${t1.div(t2)}")
}
