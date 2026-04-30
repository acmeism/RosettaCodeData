import arrays

fn print_block(data string, len u8) {
    mut a := data.split("").map(int(it.bytes()[0] - u8(48)))
    mut sum_bytes := arrays.sum(a) or {0}
    mut prep := a.map("1".repeat(it))
    println("\n" + "blocks ${a}, cells ${len}")
    if len - sum_bytes <= 0 {
        println("No solution")
        return
    }
    for r in gen_sequence(prep, len - sum_bytes + 1) {println(r[1..])}
}

fn gen_sequence(ones []string, num_zeros int) []string {
    mut result := []string{}
    mut skip_one := []string{len: ones.len}
    if ones.len == 0 {return ["0".repeat(num_zeros)]}
    for x := 1; x < num_zeros - ones.len + 2; x++ {
        skip_one = ones[1..].clone()
        for tail in gen_sequence(skip_one, num_zeros - x) {
            result << "0".repeat(x) + ones[0] + tail
        }
    }
    return result
}

fn main() {
    print_block("21", 5)
    print_block("", 5)
    print_block("8", 10)
    print_block("2323", 15)
    print_block("23", 5)
}
