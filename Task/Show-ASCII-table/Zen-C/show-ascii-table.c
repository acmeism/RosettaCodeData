fn main() {
    for i in 0..16 {
        for let j = 32 + i; j < 128; j += 16 {
            let c = "{j:c}";
            if j == 32 {
                c = "Spc";
            } else if j == 127 {
                c = "Del";
            }
            print "{j:3d} = {c:-3s}   ";
        }
        println "";
    }
}
