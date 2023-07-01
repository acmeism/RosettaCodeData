fn main() {
    for i in 0..16{
        for j := 32 + i; j < 128; j += 16 {
            mut k := u8(j).ascii_str()
            match j {
                32 {
                    k = "Spc"
                }
                127 {
                    k = "Del"
                } else {
                }
            }
            print("${j:3} : ${k:-3}   ")
        }
        println('')
    }
}
