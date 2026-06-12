fn main() {
    strings := ["1a3c52debeffd", "2b6178c97a938stf", "3ycxdb1fgxa2yz"]!
    mut u := map[rune]int{}
    for s in strings {
        mut m := map[rune]int{}
        for c in s {
            m[c]++
        }
        for k, v in m {
            if v == 1 {
                u[k]++
            }
        }
    }
    mut chars := []rune{}
    for k, v in u {
        if v == 3 {
            chars << k
        }
    }
    chars.sort()
    println(chars.string())
}
