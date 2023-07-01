fn main() {
    m := "møøse"
    u := "𝔘𝔫𝔦𝔠𝔬𝔡𝔢"
    j := "J̲o̲s̲é̲"
    println("$m.runes().len $m ${m.runes()}")
    println("$u.runes().len $u ${u.runes()}")
    println("$j.runes().len $j ${j.runes()}")
}
