fn is_pal_1(ss string) bool {
    s := ss.runes()
    for i in 0..s.len/2 {
        if s[i] != s[s.len-1-i]{
            return false
        }
    }
    return true
}

fn is_pal_2(word string) bool {
	if word == word.runes().reverse().string() {return true}
	return false
}

fn main() {
	words := ["rotor", "rosetta", "step on no pets", "été", "wren", "🦊😀🦊"]
	println('Check from is_pal_1:')
    for word in words {
        println('$word => ${is_pal_1(word)}')
    }
	println('\nCheck from is_pal_2:')
    for word in words {
        println('$word => ${is_pal_2(word)}')
    }
}
