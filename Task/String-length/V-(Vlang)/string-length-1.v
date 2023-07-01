fn main() {
    m := "møøse"
    u := "𝔘𝔫𝔦𝔠𝔬𝔡𝔢"
    j := "J̲o̲s̲é̲"
    println("$m.len $m ${m.bytes()}")
    println("$u.len $u ${u.bytes()}")
    println("$j.len $j ${j.bytes()}")
}
