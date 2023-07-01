fn main() {
    b := true
    i := 5   // default type is i32
    r := '5'
    f := 5.0  // default type is float64
    println("b: ${sizeof(b)} bytes")
    println("i: ${sizeof(i)} bytes")
    println("r: ${sizeof(r)} bytes")
    println("f: ${sizeof(f)} bytes")
    i_min := i8(5)
    r_min := `5`
    f_min := f32(5.0)
    println("i_min: ${sizeof(i_min)} bytes")
    println("r_min: ${sizeof(r_min)} bytes")
    println("f_min: ${sizeof(f_min)} bytes")
}
