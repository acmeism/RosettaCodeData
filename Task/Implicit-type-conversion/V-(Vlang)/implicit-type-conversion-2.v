u := u16(12)
x := f32(45.6)
a := 75
b := 14.7
c := u + a	// c is of type `int` - automatic promotion of `u`'s value
println(c)	// 87
d := b + x	// d is of type `f64` - automatic promotion of `x`'s value
println(d)	// 60.2999984741211
