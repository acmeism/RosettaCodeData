fn main() {
    strings := ["133252abcdeeffd", "a6789798st", "yxcdfgxcyz"]
    mut m := map[rune]int{}
    for s in strings {
        for c in s {
            m[c]++
        }
    }
    mut chars := []rune{}
    for k, v in m {
        if v == 1 {chars << k}
    }
	chars.sort_with_compare(fn(i &rune, j &rune) int {
		if *i < *j {return -1}
		if *i > *j {return 1}
		return 0
	})
	println(chars.string())
}
